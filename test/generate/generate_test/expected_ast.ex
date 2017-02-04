defmodule SwaggerPhoenixTest.GenerateTest.Models do
  @moduledoc """
  This is the expected AST for the model provided model fixture.
  """
  def expected_ast do
    {:ok, [{:defmodule, [line: 1], [{:__aliases__, [line: 1], [:SwaggerPhoenix, :Order]}, [do: {:__block__, [], [{:use, [line: 2], [{:__aliases__, [line: 2], [:SwaggerPhoenix, :Web]}, :model]}, {:schema, [line: 4], ["orders", [do: {:__block__, [], [{:field, [line: 5], [:complete, :boolean, [default: false]]}, {:field, [line: 6], [:petId, :integer]}, {:field, [line: 7], [:quantity, :integer]}, {:field, [line: 8], [:shipDate, :string]}, {:field, [line: 9], [:status, :string]}, {:timestamps, [line: 11], []}]}]]}, {:@, [line: 14], [{:doc, [line: 14], ["Builds a changeset based on the `struct` and `params`.\n"]}]}, {:def, [line: 17], [{:changeset, [line: 17], [{:struct, [line: 17], nil}, {:\\, [line: 17], [{:params, [line: 17], nil}, {:%{}, [line: 17], []}]}]}, [do: {:|>, [line: 20], [{:|>, [line: 19], [{:struct, [line: 18], nil}, {:cast, [line: 19], [{:params, [line: 19], nil}, [:complete, :petId, :quantity, :shipDate, :status]]}]}, {:validate_required, [line: 20], [[:complete, :petId, :quantity, :shipDate, :status]]}]}]]}]}]]} ]}

  end
end
