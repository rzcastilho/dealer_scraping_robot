defmodule DealerRater do
  @moduledoc """
  Finds dealer page and gets an amount of parsed reviews in `Model.Review` model.
  """

  use Hound.Helpers

  @dealerrater_url "https://www.dealerrater.com"

  @doc """
  Searches for a dealer and navigates to the first result getting reference to the reviews page.

  ## Examples

      iex> DealerRater.find_dealer_page("McKaig Chevrolet Buick")
      "/dealer/McKaig-Chevrolet-Buick-A-Dealer-For-The-People-dealer-reviews-23685/"

      iex> DealerRater.find_dealer_page("Nóis Capota Mais Num Breca")
      :notfound

      iex> DealerRater.find_dealer_page("Jack Daniels Audi")
      "/dealer/Jack-Daniels-Audi-of-Upper-Saddle-River-dealer-reviews-24186/"
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
  rescue
    _ -> :notfound
  after
    Hound.end_session
  end

  @doc """
  Gets the overly positive reviews from pages from the first to the that passed as parameter.
  """
  def get_overly_positive_reviews(:notfound, _, _) do
    %{error: "Dealer not found"}
  end

  def get_overly_positive_reviews(uri, pages, count) do
    1..pages
    |> Enum.map(fn page -> "#{uri}page#{page}" end)
    |> Enum.map(&get_review_page/1)
    |> List.flatten
    |> Enum.filter(&ReviewAnalysis.max_rating_match/1)
    |> Enum.map(&ReviewAnalysis.overly_positive_words_count/1)
    |> Enum.sort(&sort_by_overly_positive_words/2)
    |> Enum.take(count)
  end

  def get_review_page(page) do
    case DealerRaterReviews.get!(page) do
      %HTTPoison.Response{body: body} ->
        body
    end
  end

  def sort_by_overly_positive_words(%Model.Review{analysis: %Model.Analysis{overly_positive_words_count: words1}}, %Model.Review{analysis: %Model.Analysis{overly_positive_words_count: words2}}) do
    with count1 <- words1 |> Map.keys |> Enum.reduce(0, fn word, acc -> words1[word] + acc end),
         count2 <- words2 |> Map.keys |> Enum.reduce(0, fn word, acc -> words2[word] + acc end),
    do: count1 > count2
  end

end
