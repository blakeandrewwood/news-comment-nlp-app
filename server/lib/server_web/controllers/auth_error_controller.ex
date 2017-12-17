defmodule ServerWeb.AuthErrorController do
  import Plug.Conn
  use ServerWeb, :controller

  def auth_error(conn, {_type, _reason}, _opts) do
    conn
    |> put_status(:unauthorized)
    |> render(ServerWeb.ErrorView, :"400")
  end
end