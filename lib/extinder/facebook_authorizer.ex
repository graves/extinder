defmodule ExTinder.FacebookAuthorizer do
  use Hound.Helpers
  alias ExTinder.FacebookTokenError

  @auth_url "https://www.facebook.com/dialog/oauth?client_id=464891386855067&redirect_uri=https://www.facebook.com/connect/login_success.html&scope=basic_info,email,public_profile,user_about_me,user_activities,user_birthday,user_education_history,user_friends,user_interests,user_likes,user_location,user_photos,user_relationship_details&response_type=token"

  def get_token(user, password, proxy \\ %{}) do
    Application.ensure_all_started(:hound)
    Hound.start_session(%{proxy: proxy})

    navigate_to(@auth_url)

    find_element(:id, "email")
    |> fill_field(user)

    find_element(:id, "pass")
    |> fill_field(password)

    find_element(:name, "login")
    |> click

    token_url = current_url

    Hound.end_session(self)

    extract_token_from_url(token_url)
  end

  def extract_token_from_url(url) do
    token = Regex.run(~r/=(.*?)&/, url) |> Enum.at(1)

    if String.length(token) == 1 do
      raise FacebookTokenError, code: token,
      message: "Couldn't extract token, check email/password."
    else
      token
    end
  end
end
