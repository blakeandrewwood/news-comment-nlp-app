defmodule ServerWeb.RoomChannel do
  use Phoenix.Channel

  alias Server.Content
  alias Server.DiscussionNLP

  @doc """
  On join lobby
  """
  def join("room:lobby", _message, socket) do
    {:ok, socket}
  end

  @doc """
  On join room
  """
  def join("room:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  @doc """
  Broadcasts new comment
  """
  def broadcast_new_comment(comment) do
    html = Phoenix.View.render_to_string(ServerWeb.PageView, "comment.html", comment: comment)
    ServerWeb.Endpoint.broadcast("room:lobby", "new_comment", %{"parent_id" => comment.comment_id, "html" => html})
  end

  @doc """
  Broadcasts remove comment
  """
  def broadcast_remove_comment(id) do
    ServerWeb.Endpoint.broadcast("room:lobby", "remove_comment", %{"id" => id})
  end

  @doc """
  Broadcasts update topics
  """
  def broadcast_update_topics(topics) do
    html = Phoenix.View.render_to_string(ServerWeb.PageView, "topics.html", topics: topics)
    ServerWeb.Endpoint.broadcast("room:lobby", "update_topics", %{"html" => html})
  end

  @doc """
  Broadcasts update news
  """
  def broadcast_update_news(news) do
    html = Phoenix.View.render_to_string(ServerWeb.PageView, "news.html", news: news)
    ServerWeb.Endpoint.broadcast("room:lobby", "update_news", %{"html" => html})
  end

end
