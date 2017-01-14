defmodule SwaggerPhoenixTest.GenerateTest.Models do
  def expected_ast do
    {:ok, [{:defmodule, [line: 1], [{:__aliases__, [line: 1], [:SwaggerPhoenix, :Order]},
                                    [do: {:__block__, [], [{:use, [line: 2], [{:__aliases__, [line: 2], [:SwaggerPhoenix, :Web]}, :model]},
                                                           {:schema, [line: 4], ["orders", [do: {:__block__, [],
                                                                                                 [{:field, [line: 5], [:complete, :boolean, [default: false]]},
                                                                                                  {:field, [line: 6], [:id, :integer]},
                                                                                                  {:field, [line: 7], [:petId, :integer]},
                                                                                                  {:field, [line: 8], [:quantity, :integer]},
                                                                                                  {:field, [line: 9], [:shipDate, :string]},
                                                                                                  {:field, [line: 10], [:status, :string]},
                                                                                                  {:timestamps, [line: 12], []}]}]]},
                                                           {:@, [line: 15], [{:doc, [line: 15], ["Builds a changeset based on the `struct` and `params`.\n"]}]},
                                                           {:def, [line: 18], [{:changeset, [line: 18], [{:struct, [line: 18], nil}, {:\\, [line: 18], [{:params, [line: 18], nil}, {:%{}, [line: 18], []}]}]},
                                                                               [do: {:|>, [line: 21], [
                                                                                        {:|>, [line: 20], [
                                                                                            {:struct, [line: 19], nil},
                                                                                            {:cast, [line: 20], [
                                                                                                {:params, [line: 20], nil}, [:complete, :id, :petId, :quantity, :shipDate, :status]]}]},
                                                                                        {:validate_required, [line: 21], [[:complete, :id, :petId, :quantity, :shipDate, :status]]}]}]]}]}]]},
           {:defmodule, [line: 1], [{:__aliases__, [line: 1], [:SwaggerPhoenix, :OrderTest]}, [do: {:__block__, [], [{:use, [line: 2], [{:__aliases__, [line: 2], [:SwaggerPhoenix, :ModelCase]}]}, {:alias, [line: 4], [{:__aliases__, [line: 4], [:SwaggerPhoenix, :Order]}]}, {:@, [line: 6], [{:valid_attrs, [line: 6], [{:%{}, [line: 6], [complete: true, id: 42, petId: 42, quantity: 42, shipDate: "some content", status: "some content"]}]}]}, {:@, [line: 7], [{:invalid_attrs, [line: 7], [{:%{}, [line: 7], []}]}]}, {:test, [line: 9], ["changeset with valid attributes", [do: {:__block__, [], [{:=, [line: 10], [{:changeset, [line: 10], nil}, {{:., [line: 10], [{:__aliases__, [counter: 0, line: 10], [:Order]}, :changeset]}, [line: 10], [{:%, [line: 10], [{:__aliases__, [counter: 0, line: 10], [:Order]}, {:%{}, [line: 10], []}]}, {:@, [line: 10], [{:valid_attrs, [line: 10], nil}]}]}]}, {:assert, [line: 11], [{{:., [line: 11], [{:changeset, [line: 11], nil}, :valid?]}, [line: 11], []}]}]}]]}, {:test, [line: 14], ["changeset with invalid attributes", [do: {:__block__, [], [{:=, [line: 15], [{:changeset, [line: 15], nil}, {{:., [line: 15], [{:__aliases__, [counter: 0, line: 15], [:Order]}, :changeset]}, [line: 15], [{:%, [line: 15], [{:__aliases__, [counter: 0, line: 15], [:Order]}, {:%{}, [line: 15], []}]}, {:@, [line: 15], [{:invalid_attrs, [line: 15], nil}]}]}]}, {:refute, [line: 16], [{{:., [line: 16], [{:changeset, [line: 16], nil}, :valid?]}, [line: 16], []}]}]}]]}]}]]}]}
  end
 end
