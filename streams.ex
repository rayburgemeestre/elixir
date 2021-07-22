defmodule Streams do
  @moduledoc false
  # model
  def large_lines!(path) do
    File.stream!(path)
    |> Stream.map(&String.replace(&1, "\n", ""))
    |> Enum.filter(&String.length(&1))
  end

  def lines_length!(path) do
    File.stream!(path)
    |> Enum.map(&String.length(&1))
  end

  def longest_line_length!(path) do
    File.stream!(path)
    |> Stream.map(&String.length(&1))
    |> Enum.max()
  end

  def longest_line!(path) do
    # my solution
    File.stream!(path)
    |> Stream.map(fn line -> [line, String.length(line)] end)
    |> Enum.max(fn a, b -> Enum.at(a, 1) > Enum.at(b, 1) end)
    |> Enum.at(1)

    # book author solution
    File.stream!(path)
    |> Enum.max_by(&String.length(&1))
  end

  def words_per_line!(path) do
    File.stream!(path)
    |> Enum.map(&length(String.split(&1, " ")))
  end
end
