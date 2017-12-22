# DEV-NOTES

## About Phoenix

#### Basic Concepts

- Endpoint (https://hexdocs.pm/phoenix/Phoenix.Endpoint.html#content)
  - See backend project, BackendWeb.Endpoint module comments for info about default phoenix Plugs
- Router
- Controller
- Views (Module with helper functions used by the template. Data transformation for presentation)
- Templates
  - Server Side Dynamic page that with some data gets transformed to HTML
- Contexts
  - Domains of your application. An independent/autonomous set of features

#### Layers

- Cowboy (Erlang-based HTTP Server)
  - Receives the HTTP request and creates a connection struct (using the Plug Cowboy adapter)
  - Uses another library called ranch for the connection pool
  - Each connection is a separate process on an Erlang virtual machine
- Plug
  - Web server interface for Elixir
  - Plug gives us a few ready-made implementations
    - CSRF protection
    - Sessions
    - Logging
    - Static Files Serving
    - Authentication
    - etc... Find more or Make your own!
- Ecto
- ExUnit

#### Application Structure

- Project:Application
  - Project:Supervisor
    - Repo:Supervisor (uses Ecto.Repo)
    - Endpoint:Supervisor (uses Phoenix.Endpoint)

#### Advanced Concepts

- Channels
- PubSub
- Presence

## Steps for creating a new service

1. Migrate your database (either by Ecto Migrations or by Custom SQL)
  - `mix ecto.gen.migration add_users_table`
  ```elixir
  defmodule Backend.Repo.Migrations.AddUsersTable do
    use Ecto.Migration

    def change do
      create table(:users) do
        add :name, :string
        add :email, :string
        add :password_hash, :string

        timestamps()
      end
    end
  end
  ```
  - `mix ecto.migrate`
  - or
  - `mix ecto.load -d priv/repo/migrations/sql/0000-create-users.sql`
  - `mix ecto.load -d priv/repo/migrations/sql/0001-insert-users.sql`
  - cons: It doen't show when the script fails... too bad... use bd or other tool

3. Setup your Ecto Schema
  ```elixir
  defmodule Backend.Models.User do
    use Ecto.Schema
    import Ecto.Changeset
    alias Backend.Models.User

    schema "users" do
      field :name, :string
      field :email, :string
      field :password_hash, :string

      timestamps()
    end
  end
  ```

4. Create a route
  - `get "/users", UserController, :index`

5. Create a controller
6. Create controller's actions
7. Create the View and Changeset View
  ```elixir
  defmodule BackendWeb.UserView do
    use BackendWeb, :view
    alias BackendWeb.UserView

    def render("index.json", %{users: users}) do
      %{data: render_many(users, UserView, "user.json")}
    end

    def render("show.json", %{user: user}) do
      %{data: render_one(user, UserView, "user.json")}
    end

    def render("user.json", %{user: user}) do
      %{id: user.id,
        name: user.name,
        email: user.email,
        inserted_at: user.inserted_at,
        updated_at: user.updated_at}
    end
  end
  ```

## Generalities about Elixir

#### `alias` vs `require` vs `import` vs `use`

  - *alias*, *require* and *import* are `directives`, while *use* is a `macro`
  - http://elixir-lang.github.io/getting-started/alias-require-and-import.html
