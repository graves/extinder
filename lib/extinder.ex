defmodule ExTinder do
  @moduledoc """
  Provides access interfaces for Tinder's private API

  ## Reference
  https://gist.github.com/rtt/10403467
  """

  use Application
  use HTTPoison.Base

  @doc false
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = []

    opts = [strategy: :one_for_one, name: ExTinder.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # -------------- API Client Functions --------------------------

  @doc """
  POST auth

  Returns a Tinder access token needed for authorized requests.

  ## Examples

      token = ExTinder.authenticate("myfacebookid", "myfacebooktoken")
  """
  defdelegate authenticate(facebook_id, facebook_token), to: ExTinder.Client

  @doc """
  GET pass/:id

  Dislikes (swipes left on) a user.

  ## Examples

      token |>
      ExTinder.dislike("someonesuserid")
  """
  defdelegate dislike(token, user_id), to: ExTinder.Client

  @doc """
  POST updates

  Fetches new activity, setting last activity time to now.

  ## Examples

      token |>
      ExTinder.fetch_updates
  """
  defdelegate fetch_updates(token), to: ExTinder.Client

  @doc """
  POST updates

  Fetches new activity, allowing you to specify the last activity time.

  ## Examples

      {:ok, date} = "2015-06-24T04:50:34Z" |> Timex.DateFormat.parse("{ISOz}")
      token |>
      ExTinder.fetch_updates(date)
  """
  defdelegate fetch_updates(token, time), to: ExTinder.Client

  @doc """
  GET user/recs

  Fetches profiles of recommended users who are nearby.

  ## Examples

      token |>
      ExTinder.get_nearby_users
  """
  defdelegate get_nearby_users(token), to: ExTinder.Client

  @doc """
  GET user/:id

  Fetches a users profile.

  ## Examples

      token |>
      ExTinder.info_for_user("someonesuserid")
  """
  defdelegate info_for_user(token, user_id), to: ExTinder.Client

  @doc """
  GET like/:id

  Likes (swipes right on) a user.

  ## Examples

      token |>
      ExTinder.like("someonesuserid")
  """
  defdelegate like(token, user_id), to: ExTinder.Client

  @doc """
  GET profile

  Fetches currently authenticated user's profile.

  ## Examples

      token |>
      ExTinder.profile
  """
  defdelegate profile(token), to: ExTinder.Client

  @doc """
  POST user/matches/:id

  Sends a message to a user.

  ## Examples

      token |>
      ExTinder.send_message("userid", "dang girl, is yr father a lobster?")
  """
  defdelegate send_message(token, user_id, message), to: ExTinder.Client

  @doc """
  POST user/ping

  Updates your geolocation.

  ## Examples

      token |>
      ExTinder.update_location(39, -75)
  """
  defdelegate update_location(token, latitude, longitude), to: ExTinder.Client

  # -------------- HTTPoison.Base Methods ------------------------

  @doc false
  def process_url(endpoint) do
    "https://api.gotinder.com/" <> endpoint
  end

  @doc false
  def process_request_headers(headers) when is_map(headers) do
    headers = Map.merge(default_headers, headers)
    Enum.into(headers, [])
  end

  @doc false
  def process_request_headers(headers), do: Enum.into(headers, [])

  @doc false
  def process_response_body(body) do
    JSX.decode!(body, [{:labels, :atom}])
  end

  @doc """
  Sends unauthenticated GET request to a Tinder endpoint.

  ## Examples
      ExTinder.request({:get, "secret/route"})
  """
  def request({:get, endpoint}) do
    ExTinder.get(endpoint)
  end

  @doc """
  Sends authenticated GET request to a Tinder endpoint.

  ## Examples
      ExTinder.request({:get, "secret/route", "secrettoken"})
  """
  def request({:get, endpoint, token}) do
    ExTinder.get(endpoint, auth_headers(token))
  end

  @doc """
  Sends unauthenticated POST request to a Tinder endpoint. The request
  body should be a Map.

  ## Examples
      ExTinder.request({:post, "secret/route", %{csrf: "token"}})
  """
  def request({:post, endpoint, body}) do
    ExTinder.post(endpoint, JSX.encode!(body), default_headers)
  end

  @doc """
  Sends authenticated POST request to a Tinder endpoint. The request
  body should be a Map.

  ## Examples
      ExTinder.request({:post, "secret/route", %{my: "bod"}, "mytoken"})
  """
  def request({:post, endpoint, body, token}) do
    ExTinder.post(endpoint, JSX.encode!(body), auth_headers(token))
  end

  # -------------- Default and Authenticated Headers -------------

  @spec default_headers :: map
  defp default_headers do
    %{
      "Content-Type" => "application/json; charset=utf-8",
      "User-Agent" => "Tinder/3.0.2 (iPhone; iOS 7.0.4; Scale/2.00)"
     }
  end

  @spec auth_headers(String.t) :: map
  defp auth_headers(token) do
    %{
      "Authentication" => "Token token=#{token}",
      "X-Auth-Token" => token
     }
  end
end
