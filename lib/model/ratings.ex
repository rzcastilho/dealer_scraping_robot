defmodule Model.Ratings do
  @moduledoc """
    Ratings representation in `Model.Review` model.
  """

  @derive Jason.Encoder
  defstruct [
    :customer_service,
    :quality_of_work,
    :friendliness,
    :pricing,
    :experience
  ]

end
