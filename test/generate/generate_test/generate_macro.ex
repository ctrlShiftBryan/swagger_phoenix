defmodule SwaggerPhoenixTest.GenerateTest.GenerateMacro do
  alias SwaggerPhoenix.Parse.Meta
  alias SwaggerPhoenix.Generate

  @moduledoc """
  This is used to test that our model can be generated in a macro.
  """
  defmacro __using__(_opts) do
    Generate.model(@model)
    quote do
    end
  end
end
