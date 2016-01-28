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

##### Using Hound

Before using ExTinder, you must grab your Facebook OAuth token. ExTinder.FacebookAuthorizer makes use of [Hound](https://github.com/HashNuke/hound) which supports Selenium, PhantomJS, and ChromeDriver. PhantomJS still shares one cookiejar across sessions so I prefer Selenium.

First install Selenium.

```
brew update
brew install selenium-server-standalone
```

Run Selenium.

```
selenium-server -p 4444
```

Add your preferred [driver or browser to your config.exs.](https://github.com/HashNuke/hound/blob/master/notes/configuring-hound.md)

```elixir
config :hound, driver: "selenium"
```

You can now use ExTinder.FacebookAuthorizer to grab your Facebook OAuth token.

```elixir
facebook_token = ExTinder.FacebookAuthorizer.get_token("facebook@digitalgangster.com", "mypassword")
```

If necessary, the request to facebook can also be made through a proxy. You can create a proxy using ExTinder.Model.Proxy.create and pass it to the FacebookAuthorizer. The proxy constructor takes a type and proxy string along with an optional username and password. For more information check out the docs in lib/elixir/model.ex

The proxy types supported are ["ftp", "http", "ssl", "socks", "all"]

If you want to use proxies that require authorization they must be SOCKS.

```elixir
# Proxies not requiring authorization
proxy = ExTinder.Model.Proxy.create("all", "200.54.110.196:80")
facebook_token = ExTinder.FacebookAuthorizer.get_token("facebook@digitalgangster.com", "mypassword", proxy)

# Socks proxies requiring authorization
proxy = ExTinder.Model.Proxy.create("all", "200.54.110.196:80", "my_proxy_username", "my_proxy_password")
facebook_token = ExTinder.FacebookAuthorizer.get_token("facebook@digitalgangster.com", "mypassword", proxy)
```

This can then be used with your facebook profile id to get the necessary Tinder OAuth token.

```elixir
token = ExTinder.authenticate("myfacebookid", facebook_token)
```

##### Manually

If your not in the mood for additional dependencies you can also get your Facebook OAuth token manually. The easiest way is to follow this [link](https://www.facebook.com/dialog/oauth?client_id=464891386855067&redirect_uri=https://www.facebook.com/connect/login_success.html&scope=basic_info,email,public_profile,user_about_me,user_activities,user_birthday,user_education_history,user_friends,user_interests,user_likes,user_location,user_photos,user_relationship_details&response_type=token) and read the facebook token from url you get redirected to.

If you don't know how to find your facebook id you can find it [here](http://findmyfbid.com).

Now that you have your facebook id and token you can get an OAuth token from Tinder:

```elixir
token = ExTinder.authenticate("myfacebookid", "myfacebooktoken")
```

#### API Client Functions

Most requests to Tinder's API will require your previously obtained oauth token.

Get nearby user ids:

```elixir
token
|> ExTinder.get_nearby_users
|> Enum.map(fn(r) -> r._id end)
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

##### Proxies

You can pass an ExTinder.Model.Proxy to any of the client functions and it will be used to make the request. There is more information on using proxies above in the Hound authentication section.

```elixir
proxy = ExTinder.Model.Proxy.create("all", "69.69.69.69:3128")
token = ExTinder.authenticate("myfacebookid", "myfacebooktoken", proxy)

token
|> ExTinder.like("someuserid", proxy)
```

#### Custom requests to the API

You can use ExTinder's request function to query the API for functionality not yet implemented. You can make both authenticated and unauthenticated GET and POST requests by passing the correct tuple to request.

Unauthenticated GET request:

```elixir
ExTinder.Client.request({:get, "secret/route"})
```

Authenticated GET request:

```elixir
ExTinder.Client.request({:get, "secret/route", "myoauthtoken"})
```

Unauthenticated POST request:

```elixir
ExTinder.Client.request({:post, "secret/route", %{my: body}})
```

Authenticated POST request:

```elixir
ExTinder.Client.request({:post, "secret/route", %{my: body}, "myoauthtoken"})
```
