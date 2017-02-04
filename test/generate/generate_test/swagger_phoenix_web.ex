defmodule SwaggerPhoenix.Web do
  @moduledoc """
  This is here as a stub so that the generated code for the test will compile
  since we never really ran 'mix phoenix.new'
  """
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
  @moduledoc """
  Referenced by the generated code
  """
  use ExUnit.CaseTemplate
end
