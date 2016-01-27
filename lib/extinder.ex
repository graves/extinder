defmodule ExTinder do
  @moduledoc """
  Provides access interfaces for Tinder's private API

  ## Reference
  https://gist.github.com/rtt/10403467
  """

  use Application

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

      token
      |> ExTinder.dislike("someonesuserid")
  """
  defdelegate dislike(token, user_id), to: ExTinder.Client

  @doc """
  POST updates

  Fetches new activity, setting last activity time to now.

  ## Examples

      token
      |> ExTinder.fetch_updates
  """
  defdelegate fetch_updates(token), to: ExTinder.Client

  @doc """
  POST updates

  Fetches new activity, allowing you to specify the last activity time.

  ## Examples

      {:ok, date} = "2015-06-24T04:50:34Z" |> Timex.DateFormat.parse("{ISOz}")
      token
      |> ExTinder.fetch_updates(date)
  """
  defdelegate fetch_updates(token, time), to: ExTinder.Client

  @doc """
  GET user/recs

  Fetches profiles of recommended users who are nearby.

  ## Examples

      token
      |> ExTinder.get_nearby_users
  """
  defdelegate get_nearby_users(token), to: ExTinder.Client

  @doc """
  GET user/:id

  Fetches a users profile.

  ## Examples

      token
      |> ExTinder.info_for_user("someonesuserid")
  """
  defdelegate info_for_user(token, user_id), to: ExTinder.Client

  @doc """
  GET like/:id

  Likes (swipes right on) a user.

  ## Examples

      token
      |> ExTinder.like("someonesuserid")
  """
  defdelegate like(token, user_id), to: ExTinder.Client

  @doc """
  GET profile

  Fetches currently authenticated user's profile.

  ## Examples

      token
      |> ExTinder.profile
  """
  defdelegate profile(token), to: ExTinder.Client

  @doc """
  POST user/matches/:id

  Sends a message to a user.

  ## Examples

      token
      |> ExTinder.send_message("userid", "dang girl, is yr father a lobster?")
  """
  defdelegate send_message(token, user_id, message), to: ExTinder.Client

  @doc """
  POST user/ping

  Updates your geolocation.

  ## Examples

      token
      |> ExTinder.update_location(39, -75)
  """
  defdelegate update_location(token, latitude, longitude), to: ExTinder.Client
end
