defmodule Server.DiscussionNLP do
  @moduledoc """
  DiscussionNLP module
  """

  alias Server.Content

  @doc """
  Initializes ets store
  """
  def init() do
    :ets.new(:discussion_nlp, [:set, :public, :named_table])
  end

  @doc """
  Returns current discussion news
  """
  def get_news() do
    :ets.lookup(:discussion_nlp, :news)[:news] || []
  end

  @doc """
  Returns current discussion topics
  """
  def get_topics() do
    :ets.lookup(:discussion_nlp, :topics)[:topics] || []
  end

  @doc """
  Updates topics and news
  """
  def update() do
    # Get comments
    text = Content.list_comments()
    |> Enum.reduce("", fn(c, acc) -> acc <> " " <> c.body end)

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
        :ets.insert_new(:discussion_nlp, {:topics, topics})
    end
  end

  defp update_news() do
    topics = get_topics()
    if length(topics) > 0 do
      keywords = topics
      |> Enum.slice(0, 4)
      |> Enum.reduce("", fn(t, acc) -> acc <> "+" <> t end)
      case ServerWeb.Azure.news("keywords:(" <> keywords <> ")") do
        %{status: 200, body: body} ->
          news = body["value"]
          :ets.insert(:discussion_nlp, {:news, news})
      end
    end
  end

end
