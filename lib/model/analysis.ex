defmodule Model.Analysis do
  @moduledoc """
    Ratings representation in `Model.Review` model.
  """

  @derive Jason.Encoder
  defstruct [word_count: %{}]

end
