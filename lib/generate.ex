defmodule SwaggerPhoenix.Generate do

  @doc """
  This will turn a list of model attr into the string needed for the model scaffolder
  """
  def attr_to_string(attr) do
    attr
    |> Enum.sort_by(fn({k, _}) -> k end)
    |> Enum.map(fn({name,type}) -> "#{name}:#{type}" end)
  end

  require IEx
  def model_ast(model) do
    scaffold_string = ["#{model.singular}", "#{model.plural}"] ++
                      (model.attr |> attr_to_string)


    Mix.Tasks.SwaggerPhoenix.Gen.Model.run(scaffold_string)
    # IEx.pry
  end
end
