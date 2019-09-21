defmodule ScrapingRobotTest do
  use ExUnit.Case
  doctest ScrapingRobot

  test "greets the world" do
    assert ScrapingRobot.hello() == :world
  end
end
