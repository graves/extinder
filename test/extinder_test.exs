defmodule ExTinderTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  use Timex
  doctest ExTinder

  @facebook_id "629450774"
  @facebook_token "CAAGm0PX4ZCpsBAPoss2ZBrEZAnb19TOuBlYcGuF9DnpZBdFrS2sRN3YqlxkMKqLaoiBbJRyhZCExkKT13SpjWuYfgbDHo0HA138j7XwQqQYcDgGLq3ZB5BZCVLsg7dnICLNYz4ZBR5gyWJZAKLZAvTjtS1HLzk8GoqRsBV8hk63cBlQhDGeelgBGbiIGcEjvSvdlZC3cv0gd9PnLwZDZD"
  @token ExTinder.authenticate(@facebook_id, @facebook_token)

  setup_all do
    HTTPoison.start
  end

  test "authenticate success returns an auth token" do
    use_cassette("authenticate") do
      token = ExTinder.authenticate(@facebook_id, @facebook_token)
      assert token == "48f36ffd-55ec-44e1-809a-5ce23b089a43"
    end
  end

  test "dislike swipes left" do
    use_cassette("dislike") do
      nearby_user_id = "541ef305c601707603b21596"
      {:ok, response} = @token |> ExTinder.dislike(nearby_user_id)
      assert response.body[:status] == 200
    end
  end

  test "fetch_updates using only token returns updates" do
    use_cassette("fetch_updates\\1") do
      {:ok, response} = @token |> ExTinder.fetch_updates
      assert response.body[:matches]
    end
  end

  test "fetch_updates using token and time returns updates" do
    use_cassette("fetch_updates\\2") do
      time = Date.local
      {:ok, response} = @token |> ExTinder.fetch_updates(time)
      assert response.body[:matches]
    end
  end

  test "get_nearby_users gets users who are nearby" do
    use_cassette("get_nearby_users") do
      {:ok, response} = @token |> ExTinder.get_nearby_users
      assert response.body[:results]
    end
  end

  test "info_for_user gets a users profile" do
    use_cassette("info_for_user") do
      user_id = "511082f058585a5e2c000301"
      {:ok, response} = @token |> ExTinder.info_for_user(user_id)
      assert response.body[:results][:_id] == user_id
    end
  end

  test "like swipes right" do
    use_cassette("like") do
      user_id = "511082f058585a5e2c000301"
      {:ok, response} = @token |> ExTinder.like(user_id)
      assert response.body[:likes_remaining]
    end
  end

  test "profile gets own profile" do
    use_cassette("profile") do
      {:ok, response} = @token |> ExTinder.profile
      assert response.body[:_id]
    end
  end

  test "send_message sends a message to a match" do
    # Can't test until we match
  end

  test "update_location changes users location" do
    use_cassette("update_location") do
      latitude = 39
      longitude = 75
      {:ok, response} = @token |> ExTinder.update_location(latitude, longitude)
      assert response.body[:status] == 200
    end
  end
end
