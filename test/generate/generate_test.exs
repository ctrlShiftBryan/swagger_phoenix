defmodule SwaggerPhoenixTest.GenerateTest do
  use ExUnit.Case

  alias SwaggerPhoenix.Parse.Meta

  describe "generator" do
    test "defaults to empty model " do
      model = %Meta.Model{singular: "Order",
                          plural: "orders",
                          attr: [complete: :boolean,
                                id: :integer,
                                petId: :integer,
                                quantity: :integer,
                                shipDate: :string,
                                status: :string
                                ]}


    end
  end

end
