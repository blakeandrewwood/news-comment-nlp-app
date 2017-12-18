defmodule ServerWeb.PageController do
  use ServerWeb, :controller

  alias Server.Content

  def index(conn, _params) do
    comments = Content.list_top_level_comments()
    num_comments = Content.count_comments(comments)

    conn
    |> assign(:comments, comments)
    |> assign(:num_comments, num_comments)
    |> render("index.html")
  end
end
