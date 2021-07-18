defmodule Recursion do
  @moduledoc false

  # non-tail recursion version
  def list_len([]), do: 0

  def list_len([head | tail]) do
    1 + list_len(tail)
  end

  def range(from, to) when from <= to do
    # recursive list definition
    [from | range(from + 1, to)]
  end

  def range(from, to), do: []

  def positive([head | tail]) when head > 0 do
    [head | positive(tail)]
  end

  def positive([head | tail]) do
    positive(tail)
  end

  def positive([]), do: []

  # tail recursion version
  def list_len2(list), do: calc_len(0, list)

  defp calc_len(current_len, []), do: current_len

  defp calc_len(current_len, [_head | tail]) do
    calc_len(current_len + 1, tail)
  end

  def range2(from, to) do
    make_range(from, to, [])
  end

  defp make_range(from, to, current_list) when to >= from do
    # tail recurse
    make_range(from, to - 1, [to | current_list])
  end

  defp make_range(from, to, current_list) do
    current_list
  end

  def positive2(list) do
    filter_positive(list, [])
  end

  defp filter_positive([head | tail], current_list) when head > 0 do
    filter_positive(tail, [head | current_list])
  end

  defp filter_positive([head | tail], current_list) do
    filter_positive(tail, current_list)
  end

  defp filter_positive([], current_list) do
    current_list |> Enum.reverse()
  end
end
