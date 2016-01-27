defmodule ExTinder.Mixfile do
  use Mix.Project

  def project do
    [
     app: :extinder,
     version: "0.1.0",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps,
     dialyzer: [plt_add_apps: [:httpoison, :exjsx, :timex]]
    ]
  end

  def application do
    [
      applications:
      [
        :logger,
        :httpoison,
        :exjsx,
        :tzdata
      ],
      mod: {ExTinder, []}
    ]
  end

  defp deps do
    [
      {:httpoison, "~> 0.8.0"},
      {:exjsx, "~> 3.2.0"},
      {:timex, "~> 1.0.0"},
      {:exvcr, "~> 0.7", only: :test},
      {:dialyxir, "~> 0.3", only: [:dev]},
      {:hound, "~> 0.8"}
    ]
  end
end
