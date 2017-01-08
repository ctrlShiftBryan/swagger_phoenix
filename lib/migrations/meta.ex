defmodule SwaggerPhoenix.Migrations.Meta.Migration do
  defstruct [:operation, :model, added_columns: [], deleted_columns: []]
end
