defmodule SwaggerPhoenixTest.TrackModelsTest do
  use ExUnit.Case
  doctest SwaggerPhoenix

  alias SwaggerPhoenix.Migrations.Meta
  alias SwaggerPhoenix.Parse

  require IEx
  describe "initial get state" do

    test "defaults to empty model" do
      File.rm_rf("swagger_migrations")
      {:ok, output} = SwaggerPhoenix.Migrate.existing_model_state
      assert %SwaggerPhoenix.Parse.Meta{} == output
    end

    test "creates migrations folder" do
      File.rm_rf("swagger_migrations")
      {:ok, output} = SwaggerPhoenix.Migrate.existing_model_state
      folder_created = File.ls!
                       |> Enum.any?(&(&1 == "swagger_migrations"))
      assert true == folder_created
    end

    test "creates model state file" do
      File.rm_rf("swagger_migrations")
      {:ok, output} = SwaggerPhoenix.Migrate.existing_model_state

      state_file_created = File.ls!("swagger_migrations")
                           |> Enum.any?(&(&1 == "current_state.model"))
      assert true == state_file_created
    end
  end

  describe "initial migration" do
    @tag :wip
    test "first model creates proper migration" do
      File.rm_rf("swagger_migrations")
      init_swagger = "test/fixtures/migrations/init_model_swagger.json"
      {:ok, meta} = init_swagger |> Parse.json
      [first_model | _x ] = meta.models

      {:ok, output} = SwaggerPhoenix.Migrate.from_model(first_model)

      expected = %Meta.Migration{
        operation: :create,
        model: %Parse.Meta.Model{attr: [id: :integer, status: :string],
                                                plural: "orders",
                                                singular: "Order"}
      }

      assert expected == output
    end
  end
end
