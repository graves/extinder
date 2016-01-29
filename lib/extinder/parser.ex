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
    update = struct(ExTinder.Model.Update, body)
    parse_matches(update, update.matches)
  end

  def parse_matches(update, matches) do
    matches = matches |> Enum.map(&wrap_match/1)
    %{update | matches: matches}
  end

  def wrap_match(match) do
    messages = match.messages |> Enum.map(&wrap_message/1)
    struct(ExTinder.Model.Match, %{match | messages: messages})
  end

  def wrap_message(message) do
    struct(ExTinder.Model.Message, message)
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
