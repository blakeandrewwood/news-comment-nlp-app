defmodule ServerWeb.Aylien do

  def hashtags(data) do
    url = "https://api.aylien.com/api/v1/hashtags"
    request(url, {:multipart, data})
  end

  def sentiment(data) do
    url = "https://api.aylien.com/api/v1/sentiment"
    request(url, {:multipart, data})
  end

  defp request(url, data) do
    config = Application.get_env(:server, :aylien)
    headers = ["X-AYLIEN-TextAPI-Application-ID": config[:app_id], "X-AYLIEN-TextAPI-Application-Key": config[:app_key]]
    case HTTPoison.post(url, data, headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        %{:status => 200, :body => Poison.decode!(body) }
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        %{:status => 404 }
      {:error, %HTTPoison.Error{reason: reason}} ->
        %{:status => 404, :reason => reason }
    end
  end

end
