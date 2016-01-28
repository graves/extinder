defmodule ExTinder.Base do
  @moduledoc """
  Extends HTTPoison to craft our HTTP requests.
  """

  use HTTPoison.Base

  # -------------- Error Codes -----------------------------------
  @error_code_not_found 404
  @error_code_match_not_found 500
  @error_code_not_authorized 500

  # -------------- HTTPoison.Base Methods ------------------------

  @doc false
  def process_url(endpoint) do
    "https://api.gotinder.com/" <> endpoint
  end

  @doc false
  def process_request_headers(headers) when is_map(headers) do
    headers = Map.merge(default_headers, headers)
    Enum.into(headers, [])
  end

  @doc false
  def process_request_headers(headers), do: Enum.into(headers, [])

  @doc false
  def process_response_body(body) do
    JSX.decode!(body, [{:labels, :atom}])
  end

  def request(options, proxy \\ %{}) do
    do_request(options, proxy)
    |> verify_response
  end

  def verify_response({:ok, %{body: body, headers: _, status_code: _}}) do
    case Map.get(body, :error, nil) do
      nil ->
        body
      _ ->
        parse_error(body)
    end
  end

  def verify_response({:error, error}) do
    raise(ExTinder.Error, message: inspect error)
  end

  def parse_error(%{error: message, status: code}) do
    do_parse_error(message, code)
  end

  def parse_error(%{error: message, code: code}) do
    do_parse_error(message, code)
  end

  def do_parse_error(message, code) do
    case code do
      @error_code_not_found ->
        raise ExTinder.NotFoundError, code: code, message: message
      _ ->
        raise ExTinder.Error, code: code, message: message
    end
  end

  @doc """
  Sends unauthenticated GET request to a Tinder endpoint.

  ## Examples
      ExTinder.request({:get, "secret/route"})
  """
  def do_request({:get, endpoint}, proxy) do
    get(endpoint, default_headers, transform_proxy(proxy))
  end

  @doc """
  Sends authenticated GET request to a Tinder endpoint.

  ## Examples
      ExTinder.request({:get, "secret/route", "secrettoken"})
  """
  def do_request({:get, endpoint, token}, proxy) do
    get(endpoint, auth_headers(token), transform_proxy(proxy))
  end

  @doc """
  Sends unauthenticated POST request to a Tinder endpoint. The request
  body should be a Map.

  ## Examples
      ExTinder.request({:post, "secret/route", %{csrf: "token"}})
  """
  def do_request({:post, endpoint, body}, proxy) do
    post(endpoint, JSX.encode!(body), default_headers, transform_proxy(proxy))
  end

  @doc """
  Sends authenticated POST request to a Tinder endpoint. The request
  body should be a Map.

  ## Examples
      ExTinder.request({:post, "secret/route", %{my: "bod"}, "mytoken"})
  """
  def do_request({:post, endpoint, body, token}, proxy) do
    post(endpoint, JSX.encode!(body), auth_headers(token), transform_proxy(proxy))
  end

  # -------------- Default and Authenticated Headers -------------

  @spec default_headers :: map
  defp default_headers do
    %{
      "Content-Type" => "application/json; charset=utf-8",
      "User-Agent" => "Tinder/3.0.2 (iPhone; iOS 7.0.4; Scale/2.00)"
     }
  end

  @spec auth_headers(String.t) :: map
  defp auth_headers(token) do
    %{
      "Authentication" => "Token token=#{token}",
      "X-Auth-Token" => token
     }
  end

  defp transform_proxy(proxy) when proxy == %{} do
    [proxy: nil]
  end

  defp transform_proxy(proxy) do
    case proxy.socksUsername do
      nil ->
        [proxy: proxy.socksProxy]
      _ ->
        [proxy: proxy.socksProxy, proxy_auth: {proxy.socksUsername, proxy.socksPassword}]
    end
  end
end
