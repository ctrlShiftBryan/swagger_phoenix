defmodule SwaggerPhoenixTest.GenerateTest do
  @moduledoc "tests for generating models"
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

  describe "model generator tests" do
    @tag :wip
    test "given a list of Meta.Model attr, parameters are properly formatted for scaffolding" do
      output = Generate.attr_to_string(@model.attr)
      expected = ["complete:boolean", "petId:integer", "quantity:integer", "shipDate:string", "status:string"]
      assert  output == expected
      File.rm_rf!("priv")
    end

    test "given an entire Meta.Model the AST for the model is properly generated" do
      output = Generate.model_ast(@model)
      assert  output == Models.expected_ast
      File.rm_rf!("priv")
    end

    test "given a model we can Generate.Model inside of a Macro" do
      use GenerateMacro
      order = %SwaggerPhoenix.Order2{complete: true}
      assert order.complete == true
      File.rm_rf!("priv")
    end
  end
end
