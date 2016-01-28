defmodule ExTinder.Client do
  @moduledoc """
  Provide interface for common functionalities of the Tinder API.
  """

  import ExTinder.Base
  alias ExTinder.DateUtil, as: DateUtil
  use Timex

  @doc """
  Authenticate a user and return a token.
  """
  def authenticate(facebook_id, facebook_token, proxy \\ %{}) do
    data = %{facebook_id: facebook_id, facebook_token: facebook_token}

    request({:post, "auth", data}, proxy)
    |> ExTinder.Parser.parse_auth_token
  end

  @doc """
  Dislike a user (swipe left.)
  """
  def dislike(token, user_id, proxy \\ %{}) do
    request({:get, "pass/#{user_id}", token}, proxy)
    |> ExTinder.Parser.parse_simple_response
  end

  def fetch_updates(token, time, proxy \\ %{})

  @doc """
  Check for new activity using current time.
  """
  def fetch_updates(token, :now, proxy) do
    {:ok, time} = DateUtil.format(Date.local)
    data = %{last_activity_date: time}

    request({:post, "updates", data, token}, proxy)
    |> ExTinder.Parser.parse_updates
  end

  @doc """
  Check for new activity using specified time,
  """
  def fetch_updates(token, time, proxy) do
    {:ok, time} = DateUtil.format(time)
    data = %{last_activity_date: time}

    request({:post, "updates", data, token}, proxy)
    |> ExTinder.Parser.parse_updates
  end

  @doc """
  Get list of recommended users.
  """
  def get_nearby_users(token, proxy \\ %{}) do
    request({:get, "user/recs", token}, proxy)
    |> ExTinder.Parser.parse_nearby_users
  end

  @doc """
  Get a users profile.
  """
  def info_for_user(token, user_id, proxy \\ %{}) do
    request({:get, "user/#{user_id}", token}, proxy)
    |> ExTinder.Parser.parse_user
  end

  @doc """
  Like a user (swipe right.)
  """
  def like(token, user_id, proxy \\ %{}) do
    request({:get, "like/#{user_id}", token}, proxy)
    |> ExTinder.Parser.parse_simple_response
  end

  @doc """
  Fetch your own profile.
  """
  def profile(token, proxy \\ %{}) do
    request({:get, "profile", token}, proxy)
    |> ExTinder.Parser.parse_profile
  end

  @doc """
  Send a message to a user.
  """
  def send_message(token, user_id, message, proxy \\ %{}) do
    data = %{message: message}

    request({:post, "user/matches/#{user_id}", data, token}, proxy)
    |> ExTinder.Parser.parse_simple_response
  end

  @doc """
  Update your geolocation coordinates.
  """
  def update_location(token, latitude, longitude, proxy \\ %{}) do
    data = %{lat: latitude, lon: longitude}

    request({:post, "user/ping", data, token}, proxy)
    |> ExTinder.Parser.parse_simple_response
  end
end
