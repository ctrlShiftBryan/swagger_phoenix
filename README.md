# SwaggerPhoenix

## THIS PROJECT IS STILL A COMPLETE WORK IN PROGRESS AND NOT READY TO BE USED AT ALL.

## IT IS ONLT BEING PUSHED TO GITHUB AS A WAY TO SOURCE CONTROL ITS INITIAL DEVELOPMENT

## Usage
1. Put the swagger file at the root of your project.
1. Run `mix swaggerphoenix.migrate`
1. Run `mix ecto.create` and `mix ecto.migrate`
1. Add `use SwaggerPhoenix` to the top of your Application module.
1. Run `mix phoenix.server`

## Swagger Phoenix Migrate
### Initial Migration
When you migrate a swagger file a few things happen. The swagger file is parsed into a model that can be used at compile time to generate your entire phoenix application using the standard phoenix templates. That model is persisted to disk. Ecto migrations are also created based on the swagger file.

### Additional Migrations
You can change the specification in the swagger file, run swagger migrate updating the meta model and generating diff ecto migrations.

### Overriding behavior
Generated controllers can be extended by...TODO

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `swagger_phoenix` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:swagger_phoenix, "~> 0.1.0"}]
    end
    ```

  2. Ensure `swagger_phoenix` is started before your application:

    ```elixir
    def application do
      [applications: [:swagger_phoenix]]
    end
    ```

