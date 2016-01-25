# ExTinder

Tinder client library for elixir. It uses [HTTPoison](https://github.com/edgurgel/httpoison) to call Tinder's private API.

Refer to lib/extinder.ex and test/extinder_test.exs for available functions and examples.

### Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add extinder to your list of dependencies in `mix.exs`:

        def deps do
          [{:extinder, "~> 0.0.1"}]
        end

  2. Ensure extinder is started before your application:

        def application do
          [applications: [:extinder]]
        end

### Usage

#### Authentication

Before using ExTinder, you must grab your Facebook oauth token. The easiest way is to follow this [link](https://www.facebook.com/dialog/oauth?client_id=464891386855067&redirect_uri=https://www.facebook.com/connect/login_success.html&scope=basic_info,email,public_profile,user_about_me,user_activities,user_birthday,user_education_history,user_friends,user_interests,user_likes,user_location,user_photos,user_relationship_details&response_type=token) and read the facebook token from url you get redirected to.

If you don't know how to find your Facebook ID you can find it [here](http://findmyfbid.com).

Now that you have your Facebook ID and Token you can get an oauth token from tinder:

```elixir
token = ExTinder.authenticate("myfacebookid", "myfacebooktoken")
```

#### API Client Functions

Most requests to Tinder's API will require your previously obtained oauth token.

Get nearby user ids:

```elixir
token
|> ExTinder.get_nearby_users
|> Map.fetch(:results)
|> Enum.map(fn(r) -> r[:_id])
```

Like a user (swipe right):

```elixir
token
|> ExTinder.like("someuserid")
```

Send a message to a match:

```elixir
token
|> ExTinder.send_message("userid", "dang girl is yr father a lobster?")
```

#### Custom requests to the API

You can use ExTinder's request function to query the API for functionality not yet implemented. You can make both authenticated and unauthenticated GET and POST requests by passing the correct tuple to request.

Unauthenticated GET request:

```elixir
ExTinder.request({:get, "secret/route"})
```

Authenticated GET request:

```elixir
ExTinder.request({:get, "secret/route", "myoauthtoken"})
```

Unauthenticated POST request:

```elixir
ExTinder.request({:post, "secret/route", %{my: body}})
```

Authenticated POST request:

```elixir
ExTinder.request({:post, "secret/route", %{my: body}, "myoauthtoken"})
```
