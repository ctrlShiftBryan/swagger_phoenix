defmodule SwaggerPhoenixTest do
  use ExUnit.Case
  doctest SwaggerPhoenix

  alias SwaggerPhoenix.Parse.Meta
  @tag :wip
  test "the truth" do
    meta = %Meta{
      models: [%Meta.Model{singular: "Order",
                           plural: "orders",
                           attr: [complete: :boolean,
                                  id: :integer,
                                  petId: :integer,
                                  quantity: :integer,
                                  shipDate: :string,
                                  status: :string,
                                 ]}]
    }

  end
end
