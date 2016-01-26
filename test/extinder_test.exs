defmodule ExTinderTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  use Timex
  doctest ExTinder

  @facebook_id "629450774"
  @facebook_token "CAAGm0PX4ZCpsBAND1aPoNFyeJq4BlY0eZAlnIWTKrQfTyT5JACJPjPO7XkwezUCLQR08Ok2erXcGhgbB0aNlHZBu6b0v3C8F2J33TPaqtDzOz4xmsPC6wic3uiXmZC4IimJuZAML1ZCZAkzN1QE0RhqyujNxVw226ebZCyKlmSphWBZAKmlMfO12yPVYY6fjfQMD2tvGs9ANTdAZDZD"
  @good_token "abac0ed9-dc21-4e6d-970d-6f09540c6ba2"

  setup_all do
    HTTPoison.start
  end

  test "authenticate success returns an auth token" do
    use_cassette("authenticate") do
      token = ExTinder.authenticate(@facebook_id, @facebook_token)
      assert token == "abac0ed9-dc21-4e6d-970d-6f09540c6ba2"
    end
  end

  test "dislike swipes left" do
    use_cassette("dislike") do
      nearby_user_id = "541ef305c601707603b21596"
      response = @good_token |> ExTinder.dislike(nearby_user_id)
      assert response.status == 200
    end
  end

  test "fetch_updates using only token returns updates" do
    use_cassette("fetch_updates\\1") do
      response = @good_token |> ExTinder.fetch_updates
      assert response.matches
    end
  end

  test "fetch_updates using token and time returns updates" do
    use_cassette("fetch_updates\\2") do
      time = Date.local
      response = @good_token |> ExTinder.fetch_updates(time)
      assert response.matches
    end
  end

  test "get_nearby_users gets users who are nearby" do
    use_cassette("get_nearby_users") do
      count = @good_token |> ExTinder.get_nearby_users |> Enum.count
      assert count == 15
    end
  end

  test "info_for_user gets a users profile" do
    use_cassette("info_for_user") do
      user_id = "511082f058585a5e2c000301"
      response = @good_token |> ExTinder.info_for_user(user_id)
      assert response._id == user_id
    end
  end

  test "like swipes right" do
    use_cassette("like") do
      user_id = "511082f058585a5e2c000301"
      response = @good_token |> ExTinder.like(user_id)
      assert response.likes_remaining
    end
  end

  test "profile gets own profile" do
    use_cassette("profile") do
      response = @good_token |> ExTinder.profile
      assert response._id
    end
  end

  test "send_message sends a message to a match" do
    # Can't test until we match
  end

  test "update_location changes users location" do
    use_cassette("update_location") do
      latitude = 39
      longitude = 75
      response = @good_token |> ExTinder.update_location(latitude, longitude)
      assert response.status == 200
    end
  end
end
