defmodule Mix.Tasks.SwaggerPhoenix.Migrate do
  use Mix.Task
  @moduledoc """
  The migrations for the swagger file
  """

  @shortdoc "Generates an Ecto model"
  def run(args) do
    check_type |> process
  end

  defp process({:json, file}) do
    IO.puts "swagger.json found"

    {:ok, model_state} =  file
                          |> SwaggerPhoenix.Parse.json

    # this is temp. until we add incremental migrations
    File.rm_rf "swagger_migrations"
    File.mkdir("swagger_migrations")

    File.write("swagger_migrations/current_state.model", "#{inspect model_state}")
    IO.puts "swagger_migrations/current_state.model created!"
  end
  defp process({:yaml, file}) do
    IO.puts "swagger.yaml found - but yaml not yet supported"
  end
  defp process(:not_found) do
    IO.puts "swagger file not found"
  end

  defp check_type do
    cond do
      File.exists?("swagger.json") -> {:json, "swagger.json"}
      File.exists?("swagger.yaml") -> {:yaml, "swagger.yaml"}
      true -> :not_found
    end
  end
end
