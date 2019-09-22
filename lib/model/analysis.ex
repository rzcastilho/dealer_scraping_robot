defmodule Model.Analysis do
  @moduledoc """
  Struct containing some useful analysis.
  """

  @derive Jason.Encoder
  defstruct [overly_positive_words_count: %{}]

end
