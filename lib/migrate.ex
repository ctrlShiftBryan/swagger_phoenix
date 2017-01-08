defmodule SwaggerPhoenix.Migrate do

  alias SwaggerPhoenix.Parse
  alias SwaggerPhoenix.Migrations.Meta
  alias SwaggerPhoenix.Util

  require IEx

  def from_model(%Parse.Meta.Model{singular: name} = model) do

    {:ok, current} = existing_model_state()
    {:ok, migration} = get_migration(current, model)
    {action, meta} = if is_create(current, model) do
      {:create, %Parse.Meta{models: [model | []]}}
    else
      current_code = current |> to_code
      update_index = current_code.models
                     |> Enum.find_index(&(&1.singular == model.singular && &1.plural == model.plural))
      new_models = current_code.models |> List.replace_at(update_index, model)
      {:update, %Parse.Meta{ current_code | models: new_models}}
    end
    meta |> write_state
    migration |> write_migration(action, name)
    {:ok, migration}

    # compare to existing
    # scaffold intelligent ecto migrations
      # find model adds
      #   any model no in exsting state is an add
      # find model updates
      #   find added columns
      #   find removed columns
      #   a column is name:type
      #   everything will be an add and a delete
      #   so if going from name:int to name:string
      #   it will add
      # find deletes
      #   any model not in new state is a delete

    # folder_exists?(model)
  end

  def get_migration(current, model) do
    if is_create(current, model) do
      {:ok, %Meta.Migration{operation: :create, model: model}}
    else
      current_model = current |> to_code
      old_model = current_model.models
                  |> Enum.find(&(&1.singular == model.singular
                      && &1.plural == model.plural))


      adds = model.attr -- old_model.attr
      {:ok, %Meta.Migration{operation: :update, model: model, added_columns: adds }}
    end
  end

  defp to_code(code_string) do
    {{:ok, code}, _} = code_string
                       |> Code.string_to_quoted
                       |> Code.eval_quoted
    code
  end

  def is_create(%SwaggerPhoenix.Parse.Meta{models: []}, _model) do
    true
  end
  def is_create(_, _model) do
    false
  end
  @migration_folder "swagger_migrations"

  @doc """
  This will return the current state of the swagger model. If the current state
  is empty it will create the model and write the empty state to the state
  .model file.
  """
  def existing_model_state do
    with {:files, {:ok, files}} <- {:files, File.ls},
         {:folder, true} <- {:folder, files |> Enum.any?(&(&1 == @migration_folder ))},
         {:state_file, {:ok, current_state}} <- {:state_file, File.read(@migration_folder <> "//current_state.model")}
      do
        {:ok, current_state}
      else
        {:files, _} -> {:error, "error reading files"}
        {:folder, false} -> init_state()
        {:state_file, _} -> init_state()
      _ -> :error
    end
  end

  def init_state do
    File.mkdir(@migration_folder)
    init_state = %Parse.Meta{}
    init_state |> write_state
    {:ok, init_state}
  end

  defp write_state(state) when state |> is_bitstring do
    @migration_folder <> "//current_state.model"
    |> File.write("#{state}")
  end
  defp write_state(state) do
    @migration_folder <> "//current_state.model"
    |> File.write("#{inspect state}")
  end

  defp write_migration(migration, action, name) do
    "#{@migration_folder}//#{Util.timestamp()}_#{action}_#{name |> String.downcase}.migration"
    |> File.write("#{inspect migration}")
  end

  def history_file_contains(migration_file, model) do
    search = "Parse.Meta.Model{singular: \"#{model}\""
  end
end
