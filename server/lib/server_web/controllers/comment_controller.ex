defmodule ServerWeb.CommentController do
  use ServerWeb, :controller

  alias Server.Content
  alias Server.Content.Comment

  alias Server.Accounts

  action_fallback ServerWeb.FallbackController

  def index(conn, _params) do
    comments = Content.list_comments()
    render(conn, "index.json", comments: comments)
  end

  def create(conn, %{"comment" => comment_params}) do
    user = Accounts.get_current_user(conn)
    new_comment_params = Map.put(comment_params, "user_id", user.id)
    IO.inspect new_comment_params
    with {:ok, %Comment{} = comment} <- Content.create_comment(new_comment_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", comment_path(conn, :show, comment))
      |> render("show.json", comment: comment)
    end
  end

  def show(conn, %{"id" => id}) do
    comment = Content.get_comment!(id)
    render(conn, "show.json", comment: comment)
  end

  def update(conn, %{"id" => id, "comment" => comment_params}) do
    comment = Content.get_comment!(id)

    with {:ok, %Comment{} = comment} <- Content.update_comment(comment, comment_params) do
      render(conn, "show.json", comment: comment)
    end
  end

  def delete(conn, %{"id" => id}) do
    comment = Content.get_comment!(id)
    with {:ok, %Comment{}} <- Content.delete_comment(comment) do
      send_resp(conn, :no_content, "")
    end
  end
end
