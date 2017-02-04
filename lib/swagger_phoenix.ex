defmodule SwaggerPhoenix do
  @moduledoc """
  The macro that generates everything.
  """

  alias SwaggerPhoenix.Parse.Meta
  alias SwaggerPhoenix.Generate

  defmacro __using__(_opts) do
      with {:ok, model_string_ast} <- File.read("swagger_migrations/current_state.model"),
        {{:ok, state_from_file},[]} <- model_string_ast |> Code.string_to_quoted |> Code.eval_quoted
      do
        IO.inspect "Swagger Phoenix found models"
        for model <- state_from_file.models do
          model |> Generate.model
        end
      end
    quote do
    end
  end
end
