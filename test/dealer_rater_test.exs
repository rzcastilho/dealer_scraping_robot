defmodule DealerRaterTest do
  @moduledoc false

  use ExUnit.Case
  doctest DealerRater

  test ":notfound key should return dealer not found" do
    assert %{error: "Dealer not found"} = DealerRater.get_overly_positive_reviews(:notfound, 5, 3)
  end

  test "should return 3 results" do
    assert 3 == DealerRater.get_overly_positive_reviews("/dealer/McKaig-Chevrolet-Buick-A-Dealer-For-The-People-dealer-reviews-23685/", 1, 3)
    |> Enum.count()
  end

  test "should return 5 results" do
    assert 5 == DealerRater.get_overly_positive_reviews("/dealer/McKaig-Chevrolet-Buick-A-Dealer-For-The-People-dealer-reviews-23685/", 2, 5)
    |> Enum.count()
  end

end
