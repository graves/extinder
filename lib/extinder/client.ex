defmodule ExTinder.Client do
  @moduledoc """
  Provide interface for common functionalities of the Tinder API.
  """

  alias ExTinder.DateUtil, as: DateUtil
  use Timex

  @doc """
  Authenticate a user and return a token.
  """
  def authenticate(facebook_id, facebook_token) do
    data = %{facebook_id: facebook_id, facebook_token: facebook_token}
    {:ok, response} = ExTinder.request({:post, "auth", data})
    response.body[:token]
  end

  @doc """
  Dislike a user (swipe left.)
  """
  def dislike(token, user_id) do
    ExTinder.request({:get, "pass/#{user_id}", token})
  end

  @doc """
  Check for new activity using current time.
  """
  def fetch_updates(token) do
    {:ok, time} = DateUtil.format(Date.local)
    data = %{last_activity_date: time}
    ExTinder.request({:post, "updates", data, token})
  end

  @doc """
  Check for new activity using specified time,
  """
  def fetch_updates(token, time) do
    {:ok, time} = DateUtil.format(time)
    data = %{last_activity_date: time}
    ExTinder.request({:post, "updates", data, token})
  end

  @doc """
  Get list of recommended users.
  """
  def get_nearby_users(token) do
    ExTinder.request({:get, "user/recs", token})
  end

  @doc """
  Get a users profile.
  """
  def info_for_user(token, user_id) do
    ExTinder.request({:get, "user/#{user_id}", token})
  end

  @doc """
  Like a user (swipe right.)
  """
  def like(token, user_id) do
    ExTinder.request({:get, "like/#{user_id}", token})
  end

  @doc """
  Fetch your own profile.
  """
  def profile(token) do
    ExTinder.request({:get, "profile", token})
  end

  @doc """
  Send a message to a user.
  """
  def send_message(token, user_id, message) do
    data = %{message: message}
    ExTinder.request({:post, "user/matches/#{user_id}", data, token})
  end

  @doc """
  Update your geolocation coordinates.
  """
  def update_location(token, latitude, longitude) do
    data = %{lat: latitude, lon: longitude}
    ExTinder.request({:post, "user/ping", data, token})
  end
end
