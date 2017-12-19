defmodule ServerWeb.RoomChannel do
  use Phoenix.Channel

  alias Server.Content
  alias Server.DiscussionNLP

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

  def broadcast_update_topics() do
    topics = DiscussionNLP.get_topics()
    html = Phoenix.View.render_to_string(ServerWeb.PageView, "topics.html", topics: topics)
    ServerWeb.Endpoint.broadcast("room:lobby", "update_topics", %{"html" => html})
  end

  def broadcast_update_news() do
    news = DiscussionNLP.get_news()
    html = Phoenix.View.render_to_string(ServerWeb.PageView, "news.html", news: news)
    ServerWeb.Endpoint.broadcast("room:lobby", "update_news", %{"html" => html})
  end

  def broadcast_remove_comment(%{"id" => id}) do
    ServerWeb.Endpoint.broadcast("room:lobby", "remove_comment", %{"id" => id})
  end
end
