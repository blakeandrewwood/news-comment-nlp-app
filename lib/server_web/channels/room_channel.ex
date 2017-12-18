defmodule ServerWeb.RoomChannel do
  use Phoenix.Channel

  alias Server.Content

  def join("room:lobby", _message, socket) do
    {:ok, socket}
  end

  def join("room:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def broadcast_new_comment(%{"id" => id}) do
    comment =  Content.get_comment!(id)
    html = Phoenix.View.render_to_string(ServerWeb.PageView, "comment.html", comment: comment)
    ServerWeb.Endpoint.broadcast("room:lobby", "new_comment", %{"parent_id" => comment.comment_id, "html" => html})
  end

  def broadcast_remove_comment(%{"id" => id}) do
    ServerWeb.Endpoint.broadcast("room:lobby", "remove_comment", %{"id" => id})
  end
end
