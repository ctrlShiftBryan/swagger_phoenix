defmodule SwaggerPhoenix.Util do
  @moduledoc """
  Various reusable utilities
  """

  @doc """
  returns a timestamp in the format 20170101120012. YYYYMMDDHHmmss
  """
  def timestamp do
    {{y, m, d}, {hh, mm, ss}} = :calendar.universal_time()
    "#{y}#{pad(m)}#{pad(d)}#{pad(hh)}#{pad(mm)}#{pad(ss)}"
  end

  defp pad(i) when i < 10, do: << ?0, ?0 + i >>
  defp pad(i), do: to_string(i)
end
