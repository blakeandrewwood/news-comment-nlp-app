defmodule ServerWeb.PageController do
  use ServerWeb, :controller

  alias Server.Content

  def index(conn, _params) do
    comments = Content.list_top_level_comments()
    conn
    |> assign(:comments, comments)
    |> render("index.html")
  end
end
