defmodule ExTinder.Parser do
  def parse_auth_token(body) do
    case body[:token] do
      nil ->
        raise ExTinder.AuthenticationError, message: "Invalid Facebook credentials"
      token ->
        token
    end
  end

  def parse_simple_response(body) do
    struct(ExTinder.Model.Response, body)
  end

  def parse_updates(body) do
    struct(ExTinder.Model.Update, body)
  end

  def parse_nearby_users(body) do
    body[:results]
    |> Enum.map(&wrap_user/1)
  end

  def parse_user(body) do
    wrap_user(body[:results])
  end

  def parse_profile(body) do
    struct(ExTinder.Model.Profile, body)
  end

  defp wrap_user(body) do
    struct(ExTinder.Model.User, body)
  end
end
