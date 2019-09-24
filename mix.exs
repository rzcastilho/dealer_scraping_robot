defmodule DealerScrapingRobot.MixProject do
  use Mix.Project

  def project do
    [
      app: :dealer_scraping_robot,
      version: "0.2.0",
      elixir: "~> 1.9.1",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      escript: escript(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      # Docs
      name: "Dealer Scraping Robot",
      source_url: "https://github.com/rzcastilho/dealer_scraping_robot",
      homepage_url: "https://github.com/rzcastilho/dealer_scraping_robot",
      docs: [
        main: "readme",
        extras: ["README.md"]
      ],
      aliases: aliases()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.21.2", only: [:dev, :test]},
      {:credo, "~> 1.1.4", only: [:dev, :test]},
      {:excoveralls, "~> 0.11.2", only: [:dev, :test]},
      {:httpoison, "~> 1.5"},
      {:floki, "~> 0.23.0"},
      {:hound, "~> 1.0"},
      {:timex, "~> 3.6.1"},
      {:jason, "~> 1.1"},
      {:tzdata, "~> 0.1.8", override: true}
    ]
  end

  defp escript do
    [main_module: DealerScrapingRobot]
  end

  defp aliases do
    [docs: ["docs", &copy_images/1]]
  end

  defp copy_images(_) do
    File.mkdir_p("./doc/images")
    File.cp_r("./images", "./doc/images")
  end

end
