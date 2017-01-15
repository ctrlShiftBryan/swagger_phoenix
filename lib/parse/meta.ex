defmodule SwaggerPhoenix.Parse.Meta.Model do
  @moduledoc """
  Struct for swagger meta model
  """
  defstruct [:singular, :plural, attr: []]
end

defmodule SwaggerPhoenix.Parse.Meta do
  @moduledoc """
  Struct for swagger meta model
  """
  defstruct [models: []]
end
