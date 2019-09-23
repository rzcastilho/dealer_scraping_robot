defmodule Model.Review do
  @moduledoc """
    Review representation from [www.dealerrater.com](https://www.dealerrater.com)
  """

  @derive Jason.Encoder
  defstruct [
    :user,
    :reason_for_visit,
    :title,
    :body,
    :date,
    :dealership_rating,
    ratings: Model.Ratings.__struct__,
    analysis: Model.Analysis.__struct__
  ]

end
