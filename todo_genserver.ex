defmodule TodoList do
  defstruct auto_id: 1, entries: %{}

  def new(), do: %TodoList{}

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
  use GenServer

  def start do
    {:ok, pid} = GenServer.start(__MODULE__, %{})
    pid
  end

  @impl true
  def init(_), do: {:ok, TodoList.new()}

  def add_entry(todo_server, new_entry) do
    GenServer.cast(todo_server, {:add_entry, new_entry})
  end

  def entries(todo_server, date) do
    GenServer.call(todo_server, {:entries, self(), date})
  end

  @impl true
  def handle_cast({:add_entry, new_entry}, todo_list) do
    {:noreply, TodoList.add_entry(todo_list, new_entry)}
  end

  @impl true
  def handle_call({:entries, sender, date}, _, todo_list) do
    entries = send(sender, {:todo_entries, TodoList.entries(todo_list, date)})
    {:reply, entries, todo_list}
  end

  @impl true
  def handle_call(_, _, todo_list) do
    {:reply, :error, todo_list}
  end
end

defmodule TodoList.Main do
  def run() do
    pid = TodoList.TodoServer.start()
    IO.inspect(pid)
    :sys.get_status(pid)
    TodoList.TodoServer.add_entry(pid, %{date: ~D[2018-12-19], title: "Dentist"})
    TodoList.TodoServer.add_entry(pid, %{date: ~D[2018-12-20], title: "Shopping"})
    TodoList.TodoServer.add_entry(pid, %{date: ~D[2018-12-19], title: "Movies"})
    TodoList.TodoServer.entries(pid, ~D[2018-12-19])
  end
end
