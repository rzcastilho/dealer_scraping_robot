defmodule ReviewAnalysis do
  @moduledoc false

  def word_count(%Model.Review{} = review) do
    review.body
    |> String.replace(~r/[,\.]/, "")
    |> String.downcase
    |> String.split
    |> Enum.reduce(%{}, &word_count_redude/2)
  end

  defp word_count_redude(word, acc) do
    case Map.get(acc, word) do
      nil -> Map.put(acc, word, 1)
      value -> Map.put(acc, word, value + 1)
    end
  end

end
