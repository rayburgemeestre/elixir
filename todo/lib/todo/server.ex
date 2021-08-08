defmodule Todo.Server do
  use GenServer

  def start do
    {:ok, pid} = GenServer.start(__MODULE__, %{})
    pid
  end

  @impl true
  def init(_), do: {:ok, Todo.List.new()}

  def add_entry(todo_server, new_entry) do
    GenServer.cast(todo_server, {:add_entry, new_entry})
  end

  def entries(todo_server, date) do
    GenServer.call(todo_server, {:entries, self(), date})
  end

  @impl true
  def handle_cast({:add_entry, new_entry}, todo_list) do
    {:noreply, Todo.List.add_entry(todo_list, new_entry)}
  end

  @impl true
  def handle_call({:entries, sender, date}, _, todo_list) do
    entries = send(sender, {:todo_entries, Todo.List.entries(todo_list, date)})
    {:reply, entries, todo_list}
  end

  @impl true
  def handle_call(_, _, todo_list) do
    {:reply, :error, todo_list}
  end
end
