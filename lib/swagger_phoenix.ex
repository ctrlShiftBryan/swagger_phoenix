defmodule SwaggerPhoenix do
  @moduledoc """
  The SwaggerPhoenix Application
  """

  use Application

  def start(_, _) do
    IO.puts "starting SwaggerPhoenix"
    Agent.start_link fn -> [] end
  end
end

defmodule SwaggerPhoenix.Web do
  def model do
    quote do
      use Ecto.Schema

      import Ecto.Changeset
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end

defmodule SwaggerPhoenix.ModelCase do
  use ExUnit.CaseTemplate
end
