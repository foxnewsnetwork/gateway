defmodule Gateway.Mixfile do
  use Mix.Project

  def project do
    [app: :gateway,
     version: "0.0.5",
     elixir: "~> 1.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: description,
     elixirc_paths: elixirc_paths(Mix.env),
     package: package,
     source_url: "https://github.com/foxnewsnetwork/gateway",
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger, :httpoison, :poison, :fox]]
  end

  defp elixirc_paths(:test), do: ["lib", "examples"]
  defp elixirc_paths(_),     do: ["lib"]

  defp package do
    [contributors: ["Thomas Chen - (foxnewsnetwork)"],
     licenses: ["MIT"],
     links: %{github: "https://github.com/foxnewsnetwork/gateway"}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [{:poison, ">=1.4.0"},
    {:httpoison, "~>0.7"},
    {:fox, ">=0.1.4"},
    {:earmark, "~> 0.1", only: :dev},
    {:ex_doc, "~> 0.7", only: :dev},
    {:inch_ex, "~> 0.2", only: :dev}]
  end

  defp description do
    """
    A generic set of macros and conventions to build clients to communicate with JSON REST APIs
    """
  end
end
