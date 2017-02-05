defmodule SwaggerPhoenix.Mixfile do
  use Mix.Project

  def project do
    [app: :swagger_phoenix,
     version: "0.1.0",
     elixir: "~> 1.3",
     elixirc_paths: elixirc_paths(Mix.env),
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     test_coverage: [tool: ExCoveralls],
     preferred_cli_env: ["coveralls": :test, "coveralls.detail": :test, "coveralls.post": :test, "coveralls.html": :test],
     deps: deps()]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test"]
  defp elixirc_paths(_),     do: ["lib"]

  # Configuration for the OTP application
  def application do
    [applications: [:logger]]
  end

  defp deps do
    [
      {:poison, "~> 2.2 or ~> 3.0"},
      {:phoenix_ecto, "~> 3.0", only: :test},
      {:phoenix, path: "../phoenix", override: true, only: :test},
      {:credo, "~> 0.5", only: [:dev, :test]},
      {:excoveralls, "~> 0.5", only: :test}
    ]
  end
end
