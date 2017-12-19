defmodule Server.DiscussionNLP do

  alias Server.Content

  def init() do
    :ets.new(:user_lookup, [:set, :public, :named_table])
  end

  def get_news() do
    :ets.lookup(:user_lookup, :news)[:news] || []
  end

  def get_topics() do
    :ets.lookup(:user_lookup, :topics)[:topics] || []
  end

  def update() do
    # Get comments
    text = Content.list_comments()
    |> Enum.reduce("", fn(c, acc) -> acc = acc <> " " <> c.body end)

    # Update topics
    update_topics(text)

    # Update news
    update_news()
  end

  defp update_topics(text) do
    case ServerWeb.Aylien.hashtags([{"text", text}]) do
      %{status: 200, body: body} ->
        topics = body["hashtags"]
        |> Enum.map(fn(t) -> String.replace(t, "#", "") end)
        :ets.insert_new(:user_lookup, {:topics, topics})
    end
  end

  defp update_news() do
    topics = get_topics()
    if length(topics) > 0 do
      keywords = topics
      |> Enum.slice(0, 4)
      |> Enum.reduce("", fn(t, acc) -> acc = acc <> "+" <> t end)
      case ServerWeb.Azure.news("keywords:(" <> keywords <> ")") do
        %{status: 200, body: body} ->
          news = body["value"]
          :ets.insert(:user_lookup, {:news, news})
      end
    end
  end

end
