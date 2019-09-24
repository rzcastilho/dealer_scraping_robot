defmodule DealerScrapingRobot do
  @moduledoc """
  Gets the ***"overly positive reviews"*** of the informed dealer and by default returns the first three results from the five first review pages.
  """

  @default_pages 5
  @default_count 3

  @doc """
  Main function that scrapes the overly positive reviews from a dealer.

  ## Examples

      iex> DealerScrapingRobot.main(["--help"])
      :ok

      iex> DealerScrapingRobot.main()
      :ok

      iex> DealerScrapingRobot.main(["-d", "Nóis Capota Mais Num Breca"])
      :ok

      iex> DealerScrapingRobot.main(["-d", "Nóis Capota Mais Num Breca", "-p", "1"])
      :ok

      iex> DealerScrapingRobot.main(["-d", "Nóis Capota Mais Num Breca", "-c", "1"])
      :ok

      iex> DealerScrapingRobot.main(["-d", "Nóis Capota Mais Num Breca", "-p", "1", "-c", "1"])
      :ok
  """
  def main(args \\ []) do
    args
    |> parse_args
    |> run
  end

  defp parse_args(args) do
    {options, _, _} = OptionParser.parse(
      args,
      switches: [help: :boolean, dealer: :string, pages: :integer, count: :integer],
      aliases: [h: :help, d: :dealer, p: :pages, c: :count]
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
        * -p/--pages: Review pages to analyze (default 5)
        * -c/--count: Reviews to return (default 3)
      Usage: $ ./dealer_scraping_robot -d <dealer_name> [-p <number_of_pages>] [-c <results_to_show>]
      """
    ]
  end

  defp run(dealer: dealer, pages: pages, count: count) do
    dealer
    |> DealerRater.find_dealer_page()
    |> DealerRater.get_overly_positive_reviews(pages, count)
    |> Jason.encode!(pretty: true)
    |> IO.puts
  end

  defp run(options) do
    case options[:help] do
      true ->
        run(:help)
      _ ->
        case {List.keymember?(options, :dealer, 0), List.keymember?(options, :pages, 0), List.keymember?(options, :count, 0)}  do
          {true, true, true} ->
            run(dealer: options[:dealer], pages: options[:pages], count: options[:count])
          {true, true, false} ->
            run(dealer: options[:dealer], pages: options[:pages], count: @default_count)
          {true, false, true} ->
            run(dealer: options[:dealer], pages: @default_pages, count: options[:count])
          {true, false, false} ->
            run(dealer: options[:dealer], pages: @default_pages, count: @default_count)
          _ ->
            run(:help)
      end
    end
  end

end
