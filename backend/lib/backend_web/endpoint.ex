defmodule BackendWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :backend

  socket "/socket", BackendWeb.UserSocket

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phoenix.digest
  # when deploying your static files in production.
  #
  # Adds an HTTP cache header so that the client knows that it doesn’t need to fetch them again
  plug Plug.Static,
    at: "/", from: :backend, gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Logger

  # Parse the body of a request
  # Here we get params from the request
  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison

  # Used to override the HTTP method
  # Really needed?
  plug Plug.MethodOverride
  
  # Used to change the HEAD HTTP method to GET
  # Really needed?
  plug Plug.Head

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  #
  # Plug.Session can use 2 kinds of storing types: :cookie or :ets
  #   Plug.Session.COOKIE is based on
  #     Plug.Crypto.MessageEncryptor and Plug.Crypto.MessageVerifier.
  #     Under the hood, it uses AES128-GCM algorithm
  #
  # This Plug is handy but you would probably use another plug for better
  # and well-known secure session token generation strategies (like JWT).
  #
  # Phoenix.Token has some functions around tokens also.
  plug Plug.Session,
    store: :cookie,
    key: "_backend_key",
    signing_salt: "zHnIzUhO"

  plug BackendWeb.Router

  @doc """
  Callback invoked for dynamically configuring the endpoint.

  It receives the endpoint configuration and checks if
  configuration should be loaded from the system environment.
  """
  def init(_key, config) do
    if config[:load_from_system_env] do
      port = System.get_env("PORT") || raise "expected the PORT environment variable to be set"
      {:ok, Keyword.put(config, :http, [:inet6, port: port])}
    else
      {:ok, config}
    end
  end
end
