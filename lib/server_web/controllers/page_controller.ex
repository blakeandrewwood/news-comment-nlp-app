defmodule ServerWeb.PageController do
  use ServerWeb, :controller

  alias Server.Content

  def index(conn, _params) do
    comments = Content.list_top_level_comments()
    num_comments = Content.count_comments(comments)

    Server.DiscussionNLP.update()

    news = Server.DiscussionNLP.get_news()
    topics = Server.DiscussionNLP.get_topics()

    conn
    |> assign(:comments, comments)
    |> assign(:num_comments, num_comments)
    |> assign(:news, news)
    |> assign(:topics, topics)
    |> render("index.html")
  end
end
