defmodule Pluggy.MixProject do
  use Mix.Project

  def project do
    [
      app: :pluggy,
      version: "0.5.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :plug_cowboy, :plug, :postgrex],
      mod: {Pluggy, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  def deps do
    [
      {:neotoma, "~> 1.7.3", manager: :rebar3, override: true},
      {:plug_cowboy, "~> 2.7.4"},
      {:postgrex, "~> 0.21.1"},
      {:bcrypt_elixir, "~> 3.3.2"}
    ]
  end
end
