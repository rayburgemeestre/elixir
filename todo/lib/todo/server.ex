defmodule Todo.Server do
  use GenServer

  def start(name) do
    {:ok, pid} = GenServer.start(__MODULE__, name)
    pid
  end

  @impl true
  def init(name) do
    {:ok, {name, Todo.Database.read(name) || Todo.List.new()}}
  end

  def add_entry(todo_server, new_entry) do
    GenServer.cast(todo_server, {:add_entry, new_entry})
  end

  def entries(todo_server, date) do
    GenServer.call(todo_server, {:entries, self(), date})
  end

  @impl true
  def handle_cast({:add_entry, new_entry}, {list_name, todo_list}) do
    new_list = Todo.List.add_entry(todo_list, new_entry)
    Todo.Database.save(list_name, new_list)
    {:noreply, {list_name, new_list}}
  end

  @impl true
  def handle_call({:entries, sender, date}, _, {list_name, todo_list}) do
    entries = send(sender, {:todo_entries, Todo.List.entries(todo_list, date)})
    {:reply, entries, {list_name, todo_list}}
  end

  @impl true
  def handle_call(_, _, todo_list) do
    {:reply, :error, todo_list}
  end
end
