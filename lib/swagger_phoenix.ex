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
    Generate.model(@model)
    quote do
    end
  end
end
