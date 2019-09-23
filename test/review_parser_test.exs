defmodule ReviewParserTest do
  @moduledoc false

  use ExUnit.Case

  setup do
    review = File.read!("test/review_snippet.html")
    |> Floki.parse()
    {:ok, review_html: review}
  end

  test "parses review snippet", %{review_html: review} do
    assert %Model.Review{
             analysis: %Model.Analysis{overly_positive_words_count: %{}},
             body: "The best dealer ever.",
             date: ~N[2019-09-21 00:00:00],
             dealership_rating: 50,
             ratings: %Model.Ratings{
               customer_service: 50,
               experience: 50,
               friendliness: 50,
               pricing: 50,
               quality_of_work: 50
             },
             reason_for_visit: "SALES VISIT - USED",
             title: "Thank you!!!",
             user: "rzcastilho"
           } = ReviewParser.parse(review)
  end

end
