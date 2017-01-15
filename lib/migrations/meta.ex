defmodule SwaggerPhoenix.Migrations.Meta.Migration do
  @moduledoc """
  A struct to hold swagger model migration meta info
  """
  defstruct [:operation, :model, added_columns: [], deleted_columns: []]
end
