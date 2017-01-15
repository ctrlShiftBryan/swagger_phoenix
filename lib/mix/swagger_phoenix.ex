defmodule Mix.SwaggerPhoenix do
  # Conveniences for Phoenix tasks.
  @moduledoc false

  @valid_attributes [:integer, :float, :decimal, :boolean, :map, :string,
                     :array, :references, :text, :date, :time,
                     :naive_datetime, :utc_datetime, :uuid, :binary]

  @doc """
  Copies files from source dir to target dir
  according to the given map.

  Files are evaluated against EEx according to
  the given binding.
  """
  def copy_from(apps, source_dir, target_dir, binding, mapping) when is_list(mapping) do
    roots = Enum.map(apps, &to_app_source(&1, source_dir))

    results = for {format, source_file_path, target_file_path} <- mapping do
      source =
        Enum.find_value(roots, fn root ->
          source = Path.join(root, source_file_path)
          if File.exists?(source), do: source
        end) || raise "could not find #{source_file_path} in any of the sources"

      target = Path.join(target_dir, target_file_path)

      contents =
        case format do
          :text -> File.read!(source)
          :eex  -> EEx.eval_file(source, binding)
        end
      if target |> String.contains?("repo/migrations") do
        Mix.Generator.create_file(target, contents)
      else
        contents |> Code.string_to_quoted
      end
    end

    ast_results = results
                  |> Enum.filter(fn(x) -> x != :ok end)

    overall_status = case ast_results |> Enum.all?(fn({status, _}) -> status == :ok end) do
                       true -> :ok
                       false -> :error
                     end

    just_ast = ast_results
               |> Enum.map(fn {:ok, ast} -> ast end)

    {overall_status, just_ast}
  end

  defp to_app_source(path, source_dir) when is_binary(path),
    do: Path.join(path, source_dir)
  defp to_app_source(app, source_dir) when is_atom(app),
    do: Application.app_dir(app, source_dir)

  @doc """
  Inflect path, scope, alias and more from the given name.

      iex> Mix.Phoenix.inflect("user")
      [alias: "User",
       human: "User",
       base: "Phoenix",
       module: "Phoenix.User",
       scoped: "User",
       singular: "user",
       path: "user"]

      iex> Mix.Phoenix.inflect("Admin.User")
      [alias: "User",
       human: "User",
       base: "Phoenix",
       module: "Phoenix.Admin.User",
       scoped: "Admin.User",
       singular: "user",
       path: "admin/user"]

      iex> Mix.Phoenix.inflect("Admin.SuperUser")
      [alias: "SuperUser",
       human: "Super user",
       base: "Phoenix",
       module: "Phoenix.Admin.SuperUser",
       scoped: "Admin.SuperUser",
       singular: "super_user",
       path: "admin/super_user"]
  """
  def inflect(singular) do
    my_base     = Mix.Phoenix.base
    scoped   = Phoenix.Naming.camelize(singular)
    path     = Phoenix.Naming.underscore(scoped)
    singular = path |> String.split("/") |> List.last
    module   = my_base |> Module.concat(scoped) |> inspect
    my_alias    = module |> String.split(".") |> List.last
    human    = Phoenix.Naming.humanize(singular)

    [alias: my_alias,
     human: human,
     base: my_base,
     module: module,
     scoped: scoped,
     singular: singular,
     path: path]
  end

  @doc """
  Parses the attrs as received by generators.
  """
  def attrs(attrs) do
    Enum.map(attrs, fn attr ->
      attr
      |> drop_unique()
      |> String.split(":", parts: 3)
      |> list_to_attr()
      |> validate_attr!()
    end)
  end

  @doc """
  Fetches the unique attributes from attrs.
  """
  def uniques(attrs) do
    attrs
    |> Enum.filter(&String.ends_with?(&1, ":unique"))
    |> Enum.map(& &1 |> String.split(":", parts: 2) |> hd |> String.to_atom)
  end

  @doc """
  Generates some sample params based on the parsed attributes.
  """
  def params(attrs) do
    attrs
    |> Enum.reject(fn
        {_, {:references, _}} -> true
        {_, _} -> false
       end)
    |> Enum.into(%{}, fn {k, t} -> {k, type_to_default(t)} end)
  end

  @doc """
  Checks the availability of a given module name.
  """
  def check_module_name_availability!(name) do
    name = Module.concat(Elixir, name)
    if Code.ensure_loaded?(name) do
      Mix.raise "Module name #{inspect name} is already taken, please choose another name"
    end
  end

  @doc """
  Returns the module base name based on the configuration value.

      config :my_app
        namespace: My.App

  """
  def base do
    app = otp_app()

    case Application.get_env(app, :namespace, app) do
      ^app -> app |> to_string |> Phoenix.Naming.camelize
      mod  -> mod |> inspect
    end
  end

  @doc """
  Returns the otp app from the Mix project configuration.
  """
  def otp_app do
    Mix.Project.config |> Keyword.fetch!(:app)
  end

  @doc """
  Returns all compiled modules in a project.
  """
  def modules do
    Mix.Project.compile_path
    |> Path.join("*.beam")
    |> Path.wildcard
    |> Enum.map(&beam_to_module/1)
  end

  defp beam_to_module(path) do
    path |> Path.basename(".beam") |> String.to_atom()
  end

  defp drop_unique(info) do
    prefix = byte_size(info) - 7
    case info do
      <<attr::size(prefix)-binary, ":unique">> -> attr
      _ -> info
    end
  end

  defp list_to_attr([key]), do: {String.to_atom(key), :string}
  defp list_to_attr([key, value]), do: {String.to_atom(key), String.to_atom(value)}
  defp list_to_attr([key, comp, value]) do
    {String.to_atom(key), {String.to_atom(comp), String.to_atom(value)}}
  end

  defp type_to_default({:array, _}), do: []
  defp type_to_default(:integer), do: 42
  defp type_to_default(:float), do: "120.5"
  defp type_to_default(:decimal), do: "120.5"
  defp type_to_default(:boolean), do: true
  defp type_to_default(:map), do: %{}
  defp type_to_default(:text), do: "some content"
  defp type_to_default(:date), do: %{year: 2010, month: 4, day: 17}
  defp type_to_default(:time), do: %{hour: 14, minute: 0, second: 0}
  defp type_to_default(:uuid), do: "7488a646-e31f-11e4-aace-600308960662"
  defp type_to_default(:utc_datetime), do: %{year: 2010, month: 4, day: 17, hour: 14, minute: 0, second: 0}
  defp type_to_default(:naive_datetime), do: %{year: 2010, month: 4, day: 17, hour: 14, minute: 0, second: 0}
  defp type_to_default(_), do: "some content"

  defp validate_attr!({_name, type} = attr) when type in @valid_attributes, do: attr
  defp validate_attr!({_name, {type, _}} = attr) when type in @valid_attributes, do: attr
  defp validate_attr!({_, type}) do
    Mix.raise "Unknown type `#{type}` given to generator. " <>
              "The supported types are: #{@valid_attributes |> Enum.sort() |> Enum.join(", ")}"
  end
end
