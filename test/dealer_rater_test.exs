defmodule DealerRaterTest do
  @moduledoc false

  use ExUnit.Case
  doctest DealerRater

  test ":notfound key should return dealer not found" do
    assert %{error: "Dealer not found"} = DealerRater.get_overly_positive_reviews(:notfound, 5, 3)
  end

  test "should return 3 reviews" do
    reviews = DealerRater.get_overly_positive_reviews("/dealer/McKaig-Chevrolet-Buick-A-Dealer-For-The-People-dealer-reviews-23685/", 1, 3)
    assert Enum.count(reviews) == 3
    assert %Model.Review{ratings: %Model.Ratings{}, analysis: %Model.Analysis{}} = hd(reviews)
  end

  test "should return 5 reviews" do
    reviews = DealerRater.get_overly_positive_reviews("/dealer/McKaig-Chevrolet-Buick-A-Dealer-For-The-People-dealer-reviews-23685/", 2, 5)
    assert Enum.count(reviews) == 5
    assert %Model.Review{ratings: %Model.Ratings{}, analysis: %Model.Analysis{}} = hd(reviews)
  end

end
