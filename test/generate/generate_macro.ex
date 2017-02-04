defmodule GenerateMacro do
  @moduledoc """
  This is used to test that our model can be generated in a macro.
  """
  def model do
    @model
  end

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

  defmacro __using__(_opts) do
    Generate.model(@model)
    quote do
    end
  end
end
