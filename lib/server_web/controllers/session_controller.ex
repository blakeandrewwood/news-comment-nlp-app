defmodule ServerWeb.SessionController do
  use ServerWeb, :controller

  alias Server.Accounts

  def new(conn, _) do
    render conn, "new.html"
  end

  def create(conn, %{"user" => %{"username" => username, "password" => password}}) do
    case Accounts.authenticate(%{"username" => username, "password" => password}) do
      {:ok, user} ->
        Accounts.sign_in_user(conn, user)
        |> put_flash(:info, "Welcome back!")
        |> redirect(to: "/")
      {:error, :unauthorized} ->
        conn
        |> put_flash(:error, "Password invalid.")
        |> redirect(to: session_path(conn, :new))
      {:error, :not_found} ->
        conn
        |> put_flash(:error, "Username is not registered.")
        |> redirect(to: session_path(conn, :new))
    end
  end

  def delete(conn, _) do
    Accounts.sign_out(conn)
    |> redirect(to: "/")
  end
end