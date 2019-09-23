defmodule ReviewAnalysis do
  @moduledoc """
  Useful functions to analyse reviews contents.
  """

  @overly_positive_words [
    "awesome",
    "best",
    "friendly",
    "amazing",
    "excellent",
    "better",
    "wonderful",
    "dream",
    "excellence",
    "highest",
    "knowledgeable",
    "fan"
  ]

  @doc """
  Matches just the highest rating reviews in all items.

  ## Examples

      iex> ReviewAnalysis.max_rating_match(%Model.Review{dealership_rating: 50, ratings: %Model.Ratings{customer_service: 50, experience: 50, friendliness: 50, pricing: 50, quality_of_work: 50}})
      true

      iex> ReviewAnalysis.max_rating_match(%Model.Review{dealership_rating: 40, ratings: %Model.Ratings{customer_service: 50, experience: 50, friendliness: 50, pricing: 50, quality_of_work: 50}})
      false

      iex> ReviewAnalysis.max_rating_match(%Model.Review{dealership_rating: 50, ratings: %Model.Ratings{customer_service: 0, experience: 50, friendliness: 50, pricing: 50, quality_of_work: 50}})
      false
  """
  def max_rating_match(
    %Model.Review{
      dealership_rating: 50,
      ratings: %Model.Ratings{
        customer_service: 50,
        experience: 50,
        friendliness: 50,
        pricing: 50,
        quality_of_work: 50
      }
    }
  ), do: true

  def max_rating_match(%Model.Review{}), do: false

  @doc """
  Counts overly positive words occurrences in review body.

  ## Examples

      iex> ReviewAnalysis.overly_positive_words_count(%Model.Review{body: "You are the best! Awesome! The best experience ever!"})
      %Model.Review{analysis: %Model.Analysis{overly_positive_words_count: %{"awesome" => 1, "best" => 2}}, body: "You are the best! Awesome! The best experience ever!", date: nil, dealership_rating: nil, ratings: %Model.Ratings{ customer_service: nil, experience: nil, friendliness: nil, pricing: nil, quality_of_work: nil}, reason_for_visit: nil, title: nil, user: nil}

      iex> ReviewAnalysis.overly_positive_words_count(%Model.Review{body: "Terrible experience!"})
      %Model.Review{analysis: %Model.Analysis{overly_positive_words_count: %{}}, body: "Terrible experience!", date: nil, dealership_rating: nil, ratings: %Model.Ratings{ customer_service: nil, experience: nil, friendliness: nil, pricing: nil, quality_of_work: nil}, reason_for_visit: nil, title: nil, user: nil}

      iex> ReviewAnalysis.overly_positive_words_count(%Model.Review{body: "You are the best! Awesome!"})
      %Model.Review{analysis: %Model.Analysis{overly_positive_words_count: %{"awesome" => 1, "best" => 1}}, body: "You are the best! Awesome!", date: nil, dealership_rating: nil, ratings: %Model.Ratings{ customer_service: nil, experience: nil, friendliness: nil, pricing: nil, quality_of_work: nil}, reason_for_visit: nil, title: nil, user: nil}
  """
  def overly_positive_words_count(%Model.Review{} = review) do
    word_count = review.body
    |> String.replace(~r/[,\.\!\?]/, "")
    |> String.downcase
    |> String.split
    |> Enum.reduce(%{}, &overly_positive_words_count_reduce/2)
    put_in(review.analysis.overly_positive_words_count, word_count)
  end

  defp overly_positive_words_count_reduce(word, acc) do
    case Enum.member?(@overly_positive_words, word) do
      true ->
        case Map.get(acc, word) do
          nil -> Map.put(acc, word, 1)
          value -> Map.put(acc, word, value + 1)
        end
      false ->
        acc
    end
  end

end
