defmodule SwaggerPhoenix.Generate do
  @moduledoc """
  These are used to turn the swagger model into the ecto schemas and tests.
  """

  @doc """
  This will turn a list of model attr into the string needed for the model scaffolder
  """
  def attr_to_string(attr) do
    attr
    |> Enum.sort_by(fn({k, _}) -> k end)
    |> Enum.filter(fn({name,type}) -> name != :id end)
    |> Enum.map(fn({name,type}) -> "#{name}:#{type}" end)
  end

  def model_ast(model) do
    scaffold_string = ["#{model.singular}", "#{model.plural}"] ++
                      (model.attr |> attr_to_string)

    Mix.Tasks.SwaggerPhoenix.Gen.Model.run(scaffold_string)
  end

  def model(model) do
    with {:ok, ast} <- model |> model_ast do
      ast |> Code.eval_quoted
    end
  end
end
