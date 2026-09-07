defmodule Pluggy.MixProject do
  use Mix.Project

  def project do
    [
      app: :pluggy,
      version: "0.6.0",
      elixir: "~> 1.20",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Pluggy, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  def deps do
    [
      {:bandit, "~> 1.12"},
      {:postgrex, "~> 0.22"},
      {:bcrypt_elixir, "~> 3.3.2"}
    ]
  end
end
