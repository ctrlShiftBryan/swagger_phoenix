defmodule SwaggerPhoenix do
  @moduledoc """
  The macro that generates everything.
  """

  alias SwaggerPhoenix.Parse.Meta
  alias SwaggerPhoenix.Generate

  @model %Meta.Model{singular: "Order2",
                     plural: "orders",
                     attr: [id: :integer,
                            petId: :integer,
                            quantity: :integer,
                            shipDate: :string,
                            status: :string,
                            complete: :boolean
                           ]}
  def model do
    @model
  end

  defmacro __using__(_opts) do
      with {:ok, model_string_ast} <- File.read("swagger_migrations/current_state.model"),
        {{:ok, state_from_file},[]} <- model_string_ast |> Code.string_to_quoted |> Code.eval_quoted
      do
        for model <- state_from_file.models do
          model |> Generate.model
        end
      end
    quote do
    end
  end
end
