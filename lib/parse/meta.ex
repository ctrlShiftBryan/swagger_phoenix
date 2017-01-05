defmodule SwaggerPhoenix.Parse.Meta.Model do
  defstruct [:singular, :plural, attr: []]
end

defmodule SwaggerPhoenix.Parse.Meta do
  defstruct [:models]
end
