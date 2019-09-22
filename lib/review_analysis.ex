defmodule ReviewAnalysis do
  @moduledoc false

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

  def overly_positive_words_count(%Model.Review{} = review) do
    word_count = review.body
    |> String.replace(~r/[,\.]/, "")
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
