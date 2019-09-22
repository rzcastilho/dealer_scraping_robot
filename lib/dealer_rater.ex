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

    # Searches dealer by name
    navigate_to "#{@dealerrater_url}/search/?q=" <> URI.encode(dealer)
    find_element(:class, "gs-title")
    |> inner_html()
    |> Floki.parse()
    |> Floki.attribute("href")
    |> List.first
    |> navigate_to

    # Gets the first link, click on, and find the reference for reviews page
    uri = find_element(:id, "link")
    |> inner_html()
    |> Floki.parse()
    |> Floki.find("a:fl-contains('Reviews')")
    |> Floki.attribute("href")
    |> List.first
    |> String.split("#")
    |> List.first
    uri

  after
    Hound.end_session
  end

  @doc """
  Gets the overly positive reviews from pages from the first to the that passed as parameter.
  """
  def get_overly_positive_reviews(uri, count) do
    1..count
    |> Enum.map(fn page -> "#{uri}page#{page}" end)
    |> Enum.map(&get_review_page/1)
    |> List.flatten
    |> Enum.filter(&ReviewAnalysis.max_rating_match/1)
    |> Enum.map(&ReviewAnalysis.overly_positive_words_count/1)
    |> Enum.sort()
  end

  def get_review_page(page) do
    case DealerRaterReviews.get!(page) do
      %HTTPoison.Response{body: body} ->
        body
    end
  end

  def sort_by_overly_positive_words(%Model.Review{}) do

  end

end
