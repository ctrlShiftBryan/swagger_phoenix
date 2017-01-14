defmodule SwaggerPhoenix.Mixfile do
  use Mix.Project

  def project do
    [app: :swagger_phoenix,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  def application do
    [mod: {SwaggerPhoenix, []}, applications: [:logger]]
  end

  defp deps do
    [
      {:poison, "~> 2.2 or ~> 3.0"},
      {:phoenix, path: "../phoenix", override: true}
    ]
  end
end
