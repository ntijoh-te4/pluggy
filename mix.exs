defmodule Pluggy.MixProject do
  use Mix.Project

  def project do
    [
      app: :pluggy,
      version: "0.3.0",
      elixir: "~> 1.12.3",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      applications: [:cowboy, :plug, :postgrex],
      extra_applications: [:logger],
      mod: {Pluggy, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  def deps do
    [
      {:plug_cowboy, "~> 2.5.2"},
      {:postgrex, "~> 0.15.5"},
      {:bcrypt_elixir, "~> 2.3.0"},
      {:slime, "~> 1.2.1"}
    ]
  end
end
