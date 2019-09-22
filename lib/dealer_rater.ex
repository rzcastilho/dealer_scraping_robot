defmodule DealerRater do
  @moduledoc """
  Finds dealer page and gets an amount of parsed reviews as the model below.

  ```json
  {
    "body": "I was stuck on the side of the road with a flat tire and a flat spare. I called mckaigs and spoke with Aaron in the service department and he came to me with a spare tire they had and replaced it for me! I followed him to the dealership and he got both of my tires fixed, taking all of the stress out of a stressful situation! Best customer service I’ve encountered!",
    "date": "2019-09-21T00:00:00",
    "dealership_rating": 50,
    "ratings": {
      "customer_service": 50,
      "experience": 50,
      "friendliness": 50,
      "pricing": 50,
      "quality_of_work": 50
    },
    "reason_for_visit": "SERVICE VISIT",
    "title": "Customer service",
    "user": "Jesse Garland"
  }
  ```

  """

  use Hound.Helpers

  @dealerrater_url "https://www.dealerrater.com"

  @doc """
  Searches for a dealer and navigates to the first result to get the reference to the reviews page.
  """
  def find_dealer_page(dealer) do
    Hound.start_session

    navigate_to "#{@dealerrater_url}/search/?q=" <> URI.encode(dealer)
    find_element(:class, "gs-title")
    |> inner_html()
    |> Floki.parse()
    |> Floki.attribute("href")
    |> List.first
    |> navigate_to

    link = find_element(:id, "link")
    |> inner_html()
    |> Floki.parse()
    |> Floki.find("a:fl-contains('Reviews')")
    |> Floki.attribute("href")
    |> List.first
    |> String.split("#")
    |> List.first

    Hound.end_session

    link
  end

  @doc """
  Searches for a dealer and navigates to the first result to get the reference to the reviews page.
  """
  def get_reviews(link, count) do
    1..count
    |> Enum.map(fn page -> "#{link}page#{page}" end)
    |> Enum.map(&get_review/1)
    |> List.flatten
  end

  def get_review(page) do
    case DealerRaterReviews.get!(page, [recv_timeout: 15000]) do
      %HTTPoison.Response{body: body} ->
        body
    end
  end

end
