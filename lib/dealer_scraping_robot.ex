defmodule DealerScrapingRobot do
  @moduledoc """
  Documentation for DealerScrapingRobot.
  """

  def main(args \\ []) do
    args
    |> parse_args
    |> run
  end

  defp parse_args(args) do
    {options, _, _} = OptionParser.parse(
      args,
      switches: [help: :boolean, dealer: :string, pages: :integer],
      aliases: [h: :help, d: :dealer, p: :pages]
    )
    options
  end

  defp run(:help) do
    Bunt.puts [
      :aqua,
      """
      Runs scraping robot to get the overly positive reviews from www.dealerrater.com.
      Arguments:
        * -d/--dealer: Dealer Name
        * -p/--pages: Number of review pages to analyze
      Usage: $ ./dealer_scraping_robot -d <dealer_name> [-p <number_of_pages>]
      """
    ]
  end

  defp run(dealer: dealer, pages: pages) do
    dealer
    |> DealerRater.find_dealer_page()
    |> DealerRater.get_overly_positive_reviews(pages)
    |> Jason.encode!(pretty: true)
    |> IO.puts
  end

  defp run(options) do
    case options[:help] do
      true ->
        run(:help)
      _ ->
        case {List.keymember?(options, :dealer, 0), List.keymember?(options, :pages, 0)}  do
          {true, true} ->
            run(dealer: options[:dealer], pages: options[:pages])
          {true, false} ->
            run(dealer: options[:dealer], pages: 5)
          _ ->
            run(:help)
      end
    end
  end

end
