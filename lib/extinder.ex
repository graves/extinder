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
  defdelegate authenticate(facebook_id, facebook_token, proxy), to: ExTinder.Client

  @doc """
  GET pass/:id

  Dislikes (swipes left on) a user.

  ## Examples

      token
      |> ExTinder.dislike("someonesuserid")
  """
  defdelegate dislike(token, user_id), to: ExTinder.Client
  defdelegate dislike(token, user_id, proxy), to: ExTinder.Client

  @doc """
  POST updates

  Fetches new activity, allowing you to specify the last activity time. To use the current time send :now

  ## Examples

      {:ok, date} = "2015-06-24T04:50:34Z" |> Timex.DateFormat.parse("{ISOz}")
      token
      |> ExTinder.fetch_updates(date)

      token
      |> ExTinder.
  """
  defdelegate fetch_updates(token, time), to: ExTinder.Client
  defdelegate fetch_updates(token, time, proxy), to: ExTinder.Client

  @doc """
  GET user/recs

  Fetches profiles of recommended users who are nearby.

  ## Examples

      token
      |> ExTinder.get_nearby_users
  """
  defdelegate get_nearby_users(token), to: ExTinder.Client
  defdelegate get_nearby_users(token, proxy), to: ExTinder.Client

  @doc """
  GET user/:id

  Fetches a users profile.

  ## Examples

      token
      |> ExTinder.info_for_user("someonesuserid")
  """
  defdelegate info_for_user(token, user_id), to: ExTinder.Client
  defdelegate info_for_user(token, user_id, proxy), to: ExTinder.Client

  @doc """
  GET like/:id

  Likes (swipes right on) a user.

  ## Examples

      token
      |> ExTinder.like("someonesuserid")
  """
  defdelegate like(token, user_id), to: ExTinder.Client
  defdelegate like(token, user_id, proxy), to: ExTinder.Client

  @doc """
  GET profile

  Fetches currently authenticated user's profile.

  ## Examples

      token
      |> ExTinder.profile
  """
  defdelegate profile(token), to: ExTinder.Client
  defdelegate profile(token, proxy), to: ExTinder.Client

  @doc """
  POST user/matches/:id

  Sends a message to a user.

  ## Examples

      token
      |> ExTinder.send_message("matchid", "dang girl, is yr father a lobster?")
  """
  defdelegate send_message(token, match_id, message), to: ExTinder.Client
  defdelegate send_message(token, match_id, message, proxy), to: ExTinder.Client

  @doc """
  POST user/ping

  Updates your geolocation.

  ## Examples

      token
      |> ExTinder.update_location(39, -75)
  """
  defdelegate update_location(token, latitude, longitude), to: ExTinder.Client
  defdelegate update_location(token, latitude, longitude, proxy), to: ExTinder.Client

  defdelegate request(options), to: ExTinder.Base
end
