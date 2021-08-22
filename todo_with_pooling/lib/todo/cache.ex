defmodule Todo.Cache do
  use GenServer

  def start do
    GenServer.start(__MODULE__, nil, name: __MODULE__)
    Todo.Database.start()
  end

  @impl true
  def init(_), do: {:ok, %{}}

  def get(list_name) do
    GenServer.call(__MODULE__, {:get, list_name})
  end

  @impl true
  def handle_call({:get, list_name}, _, todo_lists) do
    case Map.fetch(todo_lists, list_name) do
      {:ok, todo_list} ->
        {:reply, todo_list, todo_lists}

      :error ->
        todo_list = Todo.Server.start(list_name)
        todo_lists = Map.put(todo_lists, list_name, todo_list)
        {:reply, todo_list, todo_lists}
    end
  end
end
