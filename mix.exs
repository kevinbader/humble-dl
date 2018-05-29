defmodule HumbleDl.Mixfile do
  use Mix.Project

  def project do
    [
      app: :humble_dl,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      escript: [main_module: HumbleDl],
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:optimus, "~> 0.1.0"},
      {:httpoison, "~> 1.0"},
      {:download, "~> 0.0.4"},
      {:floki, "~> 0.20.0"}
      # {:meeseeks, "~> 0.9.2"},
      # {:meeseeks_html5ever, "~> 0.8.1"}
    ]
  end
end
