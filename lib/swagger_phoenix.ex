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
