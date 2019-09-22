defmodule DealerRaterReviews do
  @moduledoc """
  Wrapper for review page calls at [www.dealerrater.com](https://www.dealerrater.com).
  """

  @endpoint "https://www.dealerrater.com"

  use HTTPoison.Base

  def process_request_url(uri) do
    @endpoint <> uri
  end

  def process_request_options(options) do
    options ++ [recv_timeout: 15000]
  end

  def process_response_body(body) do
    body
    |> Floki.parse()
    |> Floki.find("div.review-entry")
    |> Enum.map(&ReviewParser.parse/1)
  end

end

