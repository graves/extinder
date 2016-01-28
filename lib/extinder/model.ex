defmodule ExTinder.Model.Profile do
  @moduledoc """
  Profile object belonging to the authenticated user.
  """
  defstruct _id: nil, age_filter_max: nil, age_filter_min: nil, bio: nil,
    birth_date: nil, blend: nil, create_date: nil, discoverable: nil,
    distance_filter: nil, facebook_id: nil, gender: nil, gender_filter: nil,
    interested_in: nil, jobs: nil, location: nil, name: nil, photos: nil,
    ping_time: nil, pos: nil, pos_info: nil, schools: nil

  @type t :: %__MODULE__{}
end

defmodule ExTinder.Model.User do
  @moduledoc """
  User object.
  """
  defstruct _id: nil, bio: nil, birth_date: nil, birth_date_info: nil,
    common_friend_count: nil, common_friends: nil, common_like_count: nil,
    common_likes: nil, connection_count: nil, distance_mi: nil, gender: nil,
    instagram: nil, jobs: nil, name: nil, photos: nil, ping_time: nil,
    schools: nil, teaser: nil

  @type t :: %__MODULE__{}
end

defmodule ExTinder.Model.Update do
  @moduledoc """
  Update object returned when querying for activity.
  """
  defstruct blocks: nil, deleted_lists: nil, last_activity_date: nil,
    liked_messages: nil, lists: nil, matches: nil, matchmaker: nil

  @type t :: %__MODULE__{}
end

defmodule ExTinder.Model.Response do
  @moduledoc """
  Response object for simple requests.
  """
  defstruct status: nil, likes_remaining: nil, match: nil

  @type t :: %__MODULE__{}
end

defmodule ExTinder.Model.RequestToken do
  @moduledoc """
  RequestToken object needed to query for oauth token.
  """
  defstruct facebook_id: nil, facebook_token: nil

  @type t :: %__MODULE__{}
end

defmodule ExTinder.Model.AccessToken do
  @moduledoc """
  AccessToken object needed for authorized requests.
  """
  defstruct oauth_token: nil

  @type t :: %__MODULE__{}
end

defmodule ExTinder.Model.Proxy do
  @moduledoc """
  Proxy object.
  """

  defstruct proxyType: "manual", ftpProxy: nil, httpProxy: nil, sslProxy: nil,
    socksProxy: nil, socksUsername: nil, socksPassword: nil

  @type t :: %__MODULE__{}

  def create(type, proxy) do
    case type do
      "ftp" ->
        struct(%__MODULE__{}, ftpProxy: proxy)
      "http" ->
        struct(%__MODULE__{}, httpProxy: proxy)
      "ssl" ->
        struct(%__MODULE__{}, sslProxy: proxy)
      "socks" ->
        struct(%__MODULE__{}, socksProxy: proxy)
      "all" ->
        struct(%__MODULE__{}, ftpProxy: proxy, httpProxy: proxy,
               sslProxy: proxy, socksProxy: proxy)
      _ ->
        raise ExTinder.ProxyError,
          message: "Type must be ftp, http, ssl, socks, or all"
    end
  end

  def create(type, proxy, username, password) do
    case type do
      "socks" ->
        struct(%__MODULE__{}, socksProxy: proxy, socksUsername: username,
               socksPassword: password)
      "all" ->
        struct(%__MODULE__{}, ftpProxy: proxy, httpProxy: proxy,
               sslProxy: proxy, socksProxy: proxy, socksUsername: username,
               socksPassword: password)
      _ ->
        raise ExTinder.ProxyError,
          message: "For authenticated proxies type must be socks or all"
    end
  end
end
