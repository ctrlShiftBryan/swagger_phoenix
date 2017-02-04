defmodule SwaggerPhoenixTest.TrackModelsTest do
  use ExUnit.Case
  doctest SwaggerPhoenix

  alias SwaggerPhoenix.Migrations.Meta
  alias SwaggerPhoenix.Parse

  describe "initial get state" do

    test "defaults to empty model " do
      File.rm_rf("swagger_migrations")
      {:ok, output} = SwaggerPhoenix.Migrate.existing_model_state
      assert %SwaggerPhoenix.Parse.Meta{} == output
    end

    test "creates migrations folder " do
      File.rm_rf("swagger_migrations")
      {:ok, _output} = SwaggerPhoenix.Migrate.existing_model_state
      folder_created = File.ls!
                       |> Enum.any?(&(&1 == "swagger_migrations"))
      assert true == folder_created
    end

    test "creates model state file " do
      File.rm_rf("swagger_migrations")
      {:ok, _output} = SwaggerPhoenix.Migrate.existing_model_state

      state_file_created = "swagger_migrations"
                           |> File.ls!
                           |> Enum.any?(&(&1 == "current_state.model"))
      assert true == state_file_created
    end
  end

  describe "initial migration" do
    test "first model creates proper migration" do
      File.rm_rf("swagger_migrations")
      init_swagger = "test/fixtures/migrations/init_model_swagger.json"
      {:ok, meta} = init_swagger |> Parse.json
      [first_model | _x] = meta.models
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

  describe "2nd migration" do

    test "can remove a field from an existing model" do
      File.rm_rf("swagger_migrations")
      # create the initial migration
      init_swagger = "test/fixtures/migrations/model_add_field_swagger.json"
      {:ok, meta} = init_swagger |> Parse.json
      [first_model | _x] = meta.models
      {:ok, output} = SwaggerPhoenix.Migrate.from_model(first_model)

      expected = %Meta.Migration{
        operation: :create,
        model: %Parse.Meta.Model{attr: [id: :integer, newField: :string,
                                        status: :string],
                                 plural: "orders",
                                 singular: "Order"}
      }
      assert expected == output

      # add an update migration
      updated_swagger = "test/fixtures/migrations/init_model_swagger.json"
      {:ok, meta} = updated_swagger |> Parse.json
      [first_model | _x] = meta.models
      {:ok, output} = SwaggerPhoenix.Migrate.from_model(first_model)
      expected = %Meta.Migration{
        operation: :update,
        model: %Parse.Meta.Model{attr: [id: :integer, status: :string],
                                 plural: "orders",
                                 singular: "Order"},

        deleted_columns: [newField: :string]
      }
      assert expected == output

      # make sure the model state is correct
      expected_model_state = {{:ok,
                               %Parse.Meta{models:
                                           [%Parse.Meta.Model{attr:
                                                              [id: :integer,
                                                               status: :string],
                                                              plural: "orders",
                                                              singular: "Order"
                                                             }]}}, []}

      {:ok, model_string_ast} = File.read("swagger_migrations/current_state.model")
      state_from_file  = model_string_ast |> Code.string_to_quoted |> Code.eval_quoted
      assert expected_model_state == state_from_file
    end
    test "can add a field to an existing model" do
      File.rm_rf("swagger_migrations")
      init_swagger = "test/fixtures/migrations/init_model_swagger.json"
      {:ok, meta} = init_swagger |> Parse.json
      [first_model | _x] = meta.models
      {:ok, output} = SwaggerPhoenix.Migrate.from_model(first_model)

      expected = %Meta.Migration{
        operation: :create,
        model: %Parse.Meta.Model{attr: [id: :integer, status: :string],
                                 plural: "orders",
                                 singular: "Order"}
      }
      assert expected == output

      updated_swagger = "test/fixtures/migrations/model_add_field_swagger.json"
      {:ok, meta} = updated_swagger |> Parse.json
      [first_model | _x] = meta.models
      {:ok, output} = SwaggerPhoenix.Migrate.from_model(first_model)
      expected = %Meta.Migration{
        operation: :update,
        model: %Parse.Meta.Model{attr: [id: :integer, newField: :string,
                                        status: :string],
                                 plural: "orders",
                                 singular: "Order"},

        added_columns: [newField: :string]
      }
      assert expected == output

      expected_model_state = {{:ok,
                               %Parse.Meta{models:
                                           [%Parse.Meta.Model{attr:
                                                              [id: :integer,
                                                               newField: :string,
                                                               status: :string],
                                                              plural: "orders",
                                                              singular: "Order"
                                                             }]}}, []}

      {:ok, model_string_ast} = File.read("swagger_migrations/current_state.model")
      state_from_file  = model_string_ast |> Code.string_to_quoted |> Code.eval_quoted
      assert expected_model_state == state_from_file
    end
  end
end
