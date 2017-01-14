defmodule SwaggerPhoenixTest.GenerateTest do
  use ExUnit.Case

  alias SwaggerPhoenix.Parse.Meta
  alias SwaggerPhoenix.Generate

  @model %Meta.Model{singular: "Order",
                      plural: "orders",
                      attr: [id: :integer,
                            petId: :integer,
                            quantity: :integer,
                            shipDate: :string,
                            status: :string,
                            complete: :boolean
                            ]}

  describe "generator tests" do
    test "attr string is formatted properly" do
      output = Generate.attr_to_string(@model.attr)
      expected = "complete:boolean id:integer petId:integer quantity:integer shipDate:string status:string"
      assert  output == expected
    end
  end

end
