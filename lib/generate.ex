defmodule SwaggerPhoenix.Generate do

  @doc """
  This will turn a list of model attr into the string needed for the model scaffolder
  """
  def attr_to_string(attr) do
    attr
    |> Enum.sort_by(fn({k, _}) -> k end)
    |> do_attr_to_string
  end
  defp do_attr_to_string([{name, type} | []]) do
    "#{name}:#{type}"
  end
  defp do_attr_to_string([{name, type} | tail]) do
    "#{name}:#{type} " <> attr_to_string(tail)
  end
end
