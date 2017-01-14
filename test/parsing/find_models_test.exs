defmodule SwaggerPhoenixTest.FindModelsTest do
  use ExUnit.Case
  doctest SwaggerPhoenix

  alias SwaggerPhoenix.Parse.Meta

  test "can find single model" do
    {:ok, model} = SwaggerPhoenix.Parse.json("test/fixtures/single_model_swagger.json")

    expected = %Meta{
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

    assert expected == model
  end
end
