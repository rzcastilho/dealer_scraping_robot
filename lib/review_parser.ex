defmodule ReviewParser do
  @moduledoc """
    Parses the review snippets from www.dealerrater.com into `Model.Review` model.
  """

  def parse(review) do
    %Model.Review{
      user: get_user(review),
      reason_for_visit: get_reason_to_visit(review),
      title: get_title(review),
      body: get_body(review),
      date: get_date(review),
      dealership_rating: get_dealership_rating(review),
      ratings: get_individual_ratings(review)
    }
  end

  defp get_body(review) do
    review
    |> Floki.find("p.review-content")
    |> Floki.text
    |> String.trim
  end

  defp get_title(review) do
    review
    |> Floki.find("div.review-wrapper")
    |> Floki.find("div.margin-bottom-sm,div.line-height-150")
    |> Floki.find("h3")
    |> Floki.text
    |> String.replace(~r/^"|"$/, "")
    |> String.trim
  end

  defp get_user(review) do
    review
    |> Floki.find("div.review-wrapper")
    |> Floki.find("div.margin-bottom-sm,div.line-height-150")
    |> Floki.find("span")
    |> Floki.text
    |> String.split(~r/ *- */)
    |> List.last
    |> String.trim
  end

  defp get_reason_to_visit(review) do
    review
    |> Floki.find("div.dealership-rating")
    |> Floki.find("div.small-text.dr-grey")
    |> Floki.text
    |> String.trim
  end

  defp get_dealership_rating(review) do
    review
    |> Floki.find("div.dealership-rating")
    |> Floki.find("div.rating-static.hidden-xs.margin-center")
    |> Floki.attribute("class")
    |> List.first
    |> String.split
    |> Enum.filter(&(String.starts_with?(&1, "rating-")) && !String.ends_with?(&1, "-static"))
    |> List.first
    |> rating_matcher()
  end

  defp get_individual_ratings(review) do
    [customer_service, quality_of_work, friendliness, pricing, experience] = review
    |> Floki.find("div.rating-static-indv")
    |> Floki.attribute("class")
    |> Enum.map(&String.split/1)
    |> List.flatten
    |> Enum.filter(&(String.starts_with?(&1, "rating-")) && !String.ends_with?(&1, "-static-indv"))
    %Model.Ratings{
      customer_service: rating_matcher(customer_service),
      quality_of_work: rating_matcher(quality_of_work),
      friendliness: rating_matcher(friendliness),
      pricing: rating_matcher(pricing),
      experience: rating_matcher(experience)
    }
  end

  defp get_date(review) do
    review
    |> Floki.find("div.review-date")
    |> Floki.DeepText.get("|")
    |> String.split("|")
    |> List.first
    |> Timex.parse!("%B %d, %Y", :strftime)
  end

  defp rating_matcher("rating-" <> rating), do: String.to_integer(rating)

end
