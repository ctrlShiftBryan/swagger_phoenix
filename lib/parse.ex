defmodule SwaggerPhoenix.Parse do
  @moduledoc """
  These parse the swagger file into a meta model that is used by the rest of swagger.
  """
  alias SwaggerPhoenix.Parse.Meta

  def json(path) do
    with {:ok, json_string} <- path |> File.read,
         {:ok, json_map} <- json_string |> Poison.decode
    do
      {:ok, %Meta{models: json_map |> get_models}}
    end
  end

  defp get_models(json_map) do
    for {model_name, properties_holder} <- json_map["definitions"] do
      %Meta.Model{singular: model_name,
                  plural: (model_name |> String.downcase) <> "s",
                  attr: properties_holder |> get_properties}
    end
  end

  defp get_properties(properties_holder) do
    properties = for {"properties" ,properties = %{}} <- properties_holder, {property_name, meta} <- properties do
        {property_name |> String.to_atom, meta |> get_property_type}
    end
    
    properties
    |> Enum.sort_by(fn({k, _}) -> k end)
  end

  defp get_property_type(%{"type" => "boolean"}), do: :boolean
  defp get_property_type(%{"type" => "integer"}), do: :integer
  defp get_property_type(%{"type" => "string"}), do: :string
  defp get_property_type(_default), do: :string
end
