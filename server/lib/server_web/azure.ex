defmodule ServerWeb.Azure do

  def news(query) do
    url = "https://api.cognitive.microsoft.com/bing/v7.0/news/search?q=" <> query
    IO.inspect url
    request(url)
  end

  defp request(url) do
    config = Application.get_env(:server, :azure)
    headers = ["Ocp-Apim-Subscription-Key": config[:key_1]]
    case HTTPoison.get(url, headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        %{:status => 200, :body => Poison.decode!(body) }
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        %{:status => 404 }
      {:error, %HTTPoison.Error{reason: reason}} ->
        %{:status => 404, :reason => reason }
    end
  end

end
