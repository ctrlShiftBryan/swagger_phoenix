defmodule SwaggerPhoenixTest.GenerateTest do
  use ExUnit.Case

  alias SwaggerPhoenix.Parse.Meta
  alias SwaggerPhoenix.Generate
  alias SwaggerPhoenixTest.GenerateTest.Models

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
      expected = ["complete:boolean", "id:integer", "petId:integer", "quantity:integer", "shipDate:string", "status:string"]
      assert  output == expected

      File.rm_rf!("priv")
    end

    test "ast is scaffolded properly" do
      output = Generate.model_ast(@model)
      assert  output == Models.expected_ast
      File.rm_rf!("priv")
    end
  end

end
