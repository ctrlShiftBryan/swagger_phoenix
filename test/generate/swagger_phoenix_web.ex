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
