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
  end

  def model(model) do
    with {:ok, ast} <- model |> model_ast do
      ast |> Code.eval_quoted
    end
  end
end

defmodule SwaggerPhoenix.Web do
  @moduledoc """
  A module that keeps using definitions for controllers,
  views and so on.

  This can be used in your application as:

  use Foo.Web, :controller
  use Foo.Web, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below.
  """

  def model do
    quote do
      use Ecto.Schema

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
    end
  end
end
