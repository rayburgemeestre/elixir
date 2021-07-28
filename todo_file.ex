defmodule TodoList do
  defstruct auto_id: 1, entries: %{}

  def new(entries \\ []) do
    Enum.reduce(
      entries,
      %TodoList{},
      fn entry, acc -> add_entry(acc, entry) end
    )
  end

  def add_entry(todo_list, entry) do
    new_entry = Map.put(entry, :id, todo_list.auto_id)
    new_entries = Map.put(todo_list.entries, todo_list.auto_id, new_entry)
    %TodoList{todo_list | auto_id: todo_list.auto_id + 1, entries: new_entries}
  end

  def update_entry(todo_list, id, updater_fun) do
    case Map.fetch(todo_list.entries, id) do
      :error ->
        todo_list

      {:ok, entry} ->
        new_entry = updater_fun.(entry)
        new_entries = Map.put(todo_list.entries, id, new_entry)
        %TodoList{todo_list | entries: new_entries}
    end
  end

  def delete_entry(todo_list, id) do
    case Map.pop(todo_list.entries, id) do
      {_, map} ->
        %TodoList{todo_list | entries: map}
    end
  end

  def entries(todo_list, date) do
    todo_list.entries
    |> Enum.filter(fn {_id, entry} -> entry.date == date end)
  end
end

defmodule TodoList.CvsImporter do
  def new(path) do
    path
    |> entries
    |> TodoList.new()
  end

  def entries(path) do
    path
    |> read_lines()
    |> read_date_and_title()
    |> create_entries()
  end

  defp read_lines(path) do
    File.stream!(path)
    |> Stream.map(&String.replace(&1, "\n", ""))
  end

  defp read_date_and_title(line) do
    line
    |> Stream.map(&String.split(&1, ","))
    |> Stream.map(fn [date, title] -> [String.split(date, "/"), title] end)
  end

  defp create_entries(stream) do
    Stream.map(stream, &create_entry/1)
  end

  defp create_entry([[year, month, day], title]) do
    %{date: to_date(year, month, day), title: title}
  end

  defp to_date(year, month, day) do
    # my solution
    {:ok, date} =
      Date.new(String.to_integer(year), String.to_integer(month), String.to_integer(day))

    date

    # book solution (does it more conveniently at 'splitting level')
    # [year, month, day] =
    #  date_string
    #  |> String.split("/")
    #  |> Enum.map(&String.to_integer/1)
    #
    # {:ok, date} = Date.new(year, month, day)
    # date
  end
end

defmodule TodoList.Main do
  def run() do
    TodoList.new([
      %{date: ~D[2018-12-19], title: "Dentist"},
      %{date: ~D[2018-12-20], title: "Shopping"},
      %{date: ~D[2018-12-19], title: "Movies"}
    ])
    |> IO.inspect()
  end

  def run2() do
    TodoList.CvsImporter.new("todo.txt")
  end
end
