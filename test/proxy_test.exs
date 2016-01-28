defmodule ProxyTest do
  use ExUnit.Case, async: false

  test "basic proxy constuctor returns valid proxy object for http" do
    proxy = ExTinder.Model.Proxy.create("http", "127.0.0.1:8080")
    assert proxy == %ExTinder.Model.Proxy{proxyType: "manual", ftpProxy: nil,
                                          httpProxy: "127.0.0.1:8080",
                                          sslProxy: nil, socksProxy: nil,
                                          socksUsername: nil, socksPassword: nil
                                         }
  end

  test "basic proxy constuctor returns valid proxy object for all" do
    proxy = ExTinder.Model.Proxy.create("all", "127.0.0.1:8080")
    assert proxy == %ExTinder.Model.Proxy{proxyType: "manual",
                                          ftpProxy: "127.0.0.1:8080",
                                          httpProxy: "127.0.0.1:8080",
                                          sslProxy: "127.0.0.1:8080",
                                          socksProxy: "127.0.0.1:8080",
                                          socksUsername: nil, socksPassword: nil
                                         }
  end

  test "basic proxy constructor raises error for unknown type" do
    assert_raise ExTinder.ProxyError, fn ->
      ExTinder.Model.Proxy.create("bad", "127.0.0.1:8080")
    end
  end

  test "auth proxy constuctor returns valid proxy object for socks" do
    proxy = ExTinder.Model.Proxy.create("socks", "127.0.0.1:6969",
                                        "username", "password")
    assert proxy == %ExTinder.Model.Proxy{proxyType: "manual", ftpProxy: nil,
                                          httpProxy: nil, sslProxy: nil,
                                          socksProxy: "127.0.0.1:6969",
                                          socksUsername: "username",
                                          socksPassword: "password"
                                         }
  end

  test "auth proxy constuctor returns valid proxy object for all" do
    proxy = ExTinder.Model.Proxy.create("all", "127.0.0.1:6969",
                                        "username", "password")
    assert proxy == %ExTinder.Model.Proxy{proxyType: "manual",
                                          ftpProxy: "127.0.0.1:6969",
                                          httpProxy: "127.0.0.1:6969",
                                          sslProxy: "127.0.0.1:6969",
                                          socksProxy: "127.0.0.1:6969",
                                          socksUsername: "username",
                                          socksPassword: "password"
                                         }
  end

  test "auth proxy constructor raises error for unknown type" do
    assert_raise ExTinder.ProxyError, fn ->
      ExTinder.Model.Proxy.create("http", "127.0.0.1:6969",
                                  "username", "password")
    end
  end
end
