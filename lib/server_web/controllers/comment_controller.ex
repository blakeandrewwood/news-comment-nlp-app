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

    with {:ok, %Comment{} = comment} <- Content.create_comment(new_comment_params) do

      Content.get_comment!(comment.id)
      |> ServerWeb.RoomChannel.broadcast_new_comment

      Server.DiscussionNLP.update()

      Server.DiscussionNLP.get_topics()
      |> ServerWeb.RoomChannel.broadcast_update_topics

      Server.DiscussionNLP.get_news()
      |> ServerWeb.RoomChannel.broadcast_update_news

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

  def delete(conn, %{"id" => id}) do
    comment = Content.get_comment!(id)
    user = Accounts.get_current_user(conn)

    if user.id != comment.user_id do
      conn
      |> put_status(400)
      |> render(ServerWeb.ErrorView, "error.json", %{message: "Bad Request"})
    else
      with {:ok, %Comment{}} <- Content.delete_comment(comment) do

        comment.id
        |> ServerWeb.RoomChannel.broadcast_remove_comment

        Server.DiscussionNLP.update()

        Server.DiscussionNLP.get_topics()
        |> ServerWeb.RoomChannel.broadcast_update_topics

        Server.DiscussionNLP.get_news()
        |> ServerWeb.RoomChannel.broadcast_update_news

        send_resp(conn, :no_content, "")
      end
    end
  end
end
