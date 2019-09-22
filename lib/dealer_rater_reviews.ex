defmodule DealerRaterReviews do
  @moduledoc false

  use HTTPoison.Base

  def process_request_url(url) do
    "https://www.dealerrater.com" <> url
  end

  def process_response_body(body) do
    body
    |> Floki.parse()
    |> Floki.find("div.review-entry")
    |> Enum.map(&ReviewParser.parse/1)
  end

end
