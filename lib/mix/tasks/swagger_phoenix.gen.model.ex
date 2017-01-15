defmodule Mix.Tasks.SwaggerPhoenix.Gen.Model do
  use Mix.Task

  @shortdoc "Generates an Ecto model"

  @moduledoc """
  Generates an Ecto model in your Phoenix application.

      mix phoenix.gen.model User users name:string age:integer

  The first argument is the module name followed by its plural
  name (used for the schema).

  The generated model will contain:

    * a schema file in web/models
    * a migration file for the repository

  The generated migration can be skipped with `--no-migration`.

  ## Attributes

  The resource fields are given using `name:type` syntax
  where type are the types supported by Ecto. Omitting
  the type makes it default to `:string`:

      mix phoenix.gen.model User users name age:integer

  The generator also supports `belongs_to` associations
  via references:

      mix phoenix.gen.model Post posts title user_id:references:users

  This will result in a migration with an `:integer` column
  of `:user_id` and create an index. It will also generate
  the appropriate `belongs_to` entry in the schema.

  Furthermore an array type can also be given if it is
  supported by your database, although it requires the
  type of the underlying array element to be given too:

      mix phoenix.gen.model User users nicknames:array:string

  Unique columns can be automatically generated by using:

      mix phoenix.gen.model Post posts title:unique unique_int:integer:unique

  If no data type is given, it defaults to a string.

  ## Namespaced resources

  Resources can be namespaced, for such, it is just necessary
  to namespace the first argument of the generator:

      mix phoenix.gen.model Admin.User users name:string age:integer

  ## binary_id

  Generated migration can use `binary_id` for schema's primary key
  and its references with option `--binary-id`.

  This option assumes the project was generated with the `--binary-id`
  option, that sets up models to use `binary_id` by default. If that's
  not the case you can still set all your models to use `binary_id`
  by default, by adding the following to your `model` function in
  `web/web.ex` or before the `schema` declaration:

      @primary_key {:id, :binary_id, autogenerate: true}
      @foreign_key_type :binary_id

  ## Default options

  This generator uses default options provided in the `:generators`
  configuration of the `:phoenix` application. These are the defaults:

      config :phoenix, :generators,
        migration: true,
        binary_id: false,
        sample_binary_id: "11111111-1111-1111-1111-111111111111"

  You can override those options per invocation by providing corresponding
  switches, e.g. `--no-binary-id` to use normal ids despite the default
  configuration or `--migration` to force generation of the migration.
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
      {:eex, "model.ex",       "web/models/#{path}.ex"},
      {:eex, "model_test.exs", "test/models/#{path}_test.exs"},
    ] ++ migration(opts[:migration], path)


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
