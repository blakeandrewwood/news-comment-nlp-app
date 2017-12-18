defmodule ServerWeb.PageController do
  use ServerWeb, :controller

  alias ServerWeb.Aylien
  alias Server.Content

  def index(conn, _params) do
    comments = Content.list_top_level_comments()
    num_comments = Content.count_comments(comments)

    text = Content.list_comments()
    |> Enum.reduce("", fn(c, acc) -> acc = acc <> " " <> c.body end)

    topics = []

    case Aylien.hashtags([{"text", text}]) do
      %{status: 200, body: body} ->
        topics = body["hashtags"]
    end

    case Aylien.sentiment([{"mode", "document"}, {"text", text}]) do
      %{status: 200, body: body} ->
        IO.inspect body
    end

    news = [
      %{
        :title => "Title A",
        :excerpt => "Excerpt A",
        :link => "http://google.com",
        :image => "http://materializecss.com/images/sample-1.jpg"
      },
      %{
        :title => "Title B",
        :excerpt => "Excerpt B",
        :link => "http://google.com",
        :image => "http://materializecss.com/images/sample-1.jpg"
      },
      %{
        :title => "Title C",
        :excerpt => "Excerpt C",
        :link => "http://google.com",
        :image => "http://materializecss.com/images/sample-1.jpg"
      }
    ]

    conn
    |> assign(:comments, comments)
    |> assign(:num_comments, num_comments)
    |> assign(:news, news)
    |> assign(:topics, topics)
    |> render("index.html")
  end
end
