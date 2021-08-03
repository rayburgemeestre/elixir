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

  def entries(todo_list, date) do
    todo_list.entries
    |> Enum.filter(fn {_id, entry} -> entry.date == date end)
  end
end

defmodule TodoList.TodoServer do
  def start do
    Process.register(
      spawn(fn -> loop(TodoList.new()) end),
      :todo_server
    )
  end

  def add_entry(new_entry) do
    send(:todo_server, {:add_entry, new_entry})
  end

  def entries(date) do
    send(:todo_server, {:entries, self(), date})

    receive do
      {:todo_entries, entries} -> entries
    after
      5000 -> {:error, :timeout}
    end
  end

  defp loop(todo_list) do
    todo_list =
      receive do
        message -> process_message(todo_list, message)
      end

    loop(todo_list)
  end

  defp process_message(todo_list, {:add_entry, new_entry}) do
    TodoList.add_entry(todo_list, new_entry)
  end

  defp process_message(todo_list, {:entries, sender, date}) do
    send(sender, {:todo_entries, TodoList.entries(todo_list, date)})
    todo_list
  end

  # book solution included something like this to avoid blocking messages
  defp process_message(todo_list, _), do: todo_list
end

defmodule TodoList.Main do
  def run() do
    TodoList.TodoServer.start()
    TodoList.TodoServer.add_entry(%{date: ~D[2018-12-19], title: "Dentist"})
    TodoList.TodoServer.add_entry(%{date: ~D[2018-12-20], title: "Shopping"})
    TodoList.TodoServer.add_entry(%{date: ~D[2018-12-19], title: "Movies"})
    TodoList.TodoServer.entries(~D[2018-12-19])
  end
end
