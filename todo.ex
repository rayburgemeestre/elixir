defmodule TodoList do
  defstruct auto_id: 1, entries: %{}

  def new(), do: %TodoList{}

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
    # my solution
    case Map.pop(todo_list.entries, id) do
      {_, map} ->
        %TodoList{todo_list | entries: map}
    end
    # book solution below
    %TodoList{todo_list | entries: Map.delete(todo_list.entries, entry_id)}
  end

  def entries(todo_list, date) do
    todo_list.entries
    |> Enum.filter(fn {_id, entry} -> entry.date == date end)
  end
end
