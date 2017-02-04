defmodule Mix.Tasks.SwaggerPhoenix.Gen.Model do
  use Mix.Task

  @shortdoc "Generates an Ecto model"

  @moduledoc """
  This is a copy of the phoenix model generator. The only difference compared to the one that ships with phoenix is that it returns the AST instead of writing a model file to disk.
  """
  def run(args) do
    switches = [migration: :boolean, binary_id: :boolean, instructions: :string]

    {opts, parsed, _} = OptionParser.parse(args, switches: switches)
    [singular, plural | attrs] = validate_args!(parsed)

    default_opts = Application.get_env(:phoenix, :generators, [])
    opts = Keyword.merge(default_opts, opts)

    uniques   = Mix.Phoenix.uniques(attrs)
    attrs     = Mix.Phoenix.attrs(attrs)
    binding   = Mix.Phoenix.inflect(singular)
    params    = Mix.Phoenix.params(attrs)
    path      = binding[:path]

    Mix.Phoenix.check_module_name_availability!(binding[:module])
    {assocs, attrs} = partition_attrs_and_assocs(attrs)

    binding = binding ++
              [attrs: attrs, plural: plural, types: types(attrs), uniques: uniques,
               assocs: assocs(assocs), indexes: indexes(plural, assocs, uniques),
               schema_defaults: schema_defaults(attrs), binary_id: opts[:binary_id],
               migration_defaults: migration_defaults(attrs), params: params]

    files = [
      {:eex, "model.ex",       "web/models/#{path}.ex"}
      # {:eex, "model_test.exs", "test/models/#{path}_test.exs"},
    ] # ++ migration(opts[:migration], path)

    ## removed model test and migrations for run time model migrations

    Mix.SwaggerPhoenix.copy_from paths(), "priv/templates/phoenix.gen.model", "", binding, files
  end

  defp validate_args!([_, plural | _] = args) do
    cond do
      String.contains?(plural, ":") ->
        raise_with_help()
      plural != Phoenix.Naming.underscore(plural) ->
        Mix.raise "Expected the second argument, #{inspect plural}, to be all lowercase using snake_case convention"
      true ->
        args
    end
  end

  defp validate_args!(_) do
    raise_with_help()
  end

  @spec raise_with_help() :: no_return()
  defp raise_with_help do
    Mix.raise """
    mix phoenix.gen.model expects both singular and plural names
    of the generated resource followed by any number of attributes:

        mix phoenix.gen.model User users name:string
    """
  end

  defp partition_attrs_and_assocs(attrs) do
    Enum.partition attrs, fn
      {_, {:references, _}} ->
        true
      {key, :references} ->
        Mix.raise """
        Phoenix generators expect the table to be given to #{key}:references.
        For example:

            mix phoenix.gen.model Comment comments body:text post_id:references:posts
        """
      _ ->
        false
    end
  end

  defp assocs(assocs) do
    Enum.map assocs, fn {key_id, {:references, source}} ->
      key   = String.replace(Atom.to_string(key_id), "_id", "")
      assoc = Mix.Phoenix.inflect key
      {String.to_atom(key), key_id, assoc[:module], source}
    end
  end

  defp indexes(plural, assocs, uniques) do
      uniques 
      |> Enum.map(fn key -> {key, true} end)
      |> Enum.concat(Enum.map(assocs, fn {key, _} -> {key, false} end))
      |> Enum.uniq_by(fn {key, _} -> key end)
      |> Enum.map(fn
                    {key, false} -> "create index(:#{plural}, [:#{key}])"
                    {key, true}  -> "create unique_index(:#{plural}, [:#{key}])"
                  end)
  end

  defp migration(false, _path), do: []
  defp migration(_, path) do
    [{:eex, "migration.exs",
      "priv/repo/migrations/#{timestamp()}_create_#{String.replace(path, "/", "_")}.exs"}]
  end

  defp timestamp do
    {{y, m, d}, {hh, mm, ss}} = :calendar.universal_time()
    "#{y}#{pad(m)}#{pad(d)}#{pad(hh)}#{pad(mm)}#{pad(ss)}"
  end

  defp pad(i) when i < 10, do: << ?0, ?0 + i >>
  defp pad(i), do: to_string(i)

  defp types(attrs) do
    Enum.into attrs, %{}, fn
      {k, {c, v}}       -> {k, {c, value_to_type(v)}}
      {k, v}            -> {k, value_to_type(v)}
    end
  end

  defp schema_defaults(attrs) do
    Enum.into attrs, %{}, fn
      {k, :boolean}  -> {k, ", default: false"}
      {k, _}         -> {k, ""}
    end
  end

  defp migration_defaults(attrs) do
    Enum.into attrs, %{}, fn
      {k, :boolean}  -> {k, ", default: false, null: false"}
      {k, _}         -> {k, ""}
    end
  end

  defp value_to_type(:text), do: :string
  defp value_to_type(:uuid), do: Ecto.UUID
  defp value_to_type(v) do
    if Code.ensure_loaded?(Ecto.Type) and not Ecto.Type.primitive?(v) do
      Mix.raise "Unknown type `#{v}` given to generator"
    else
      v
    end
  end

  defp paths do
    [".", :phoenix]
  end
end
