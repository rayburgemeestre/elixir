defmodule Todo.Cache do
  use GenServer

  def start do
    {:ok, pid} = GenServer.start(__MODULE__, %{})
    pid
  end

  @impl true
  def init(_), do: {:ok, %{}}

  def get(cache, list_name) do
    GenServer.call(cache, {:get, self(), list_name})
  end

  @impl true
  def handle_call({:get, sender, list_name}, _, todo_lists) do
    case Map.fetch(todo_lists, list_name) do
      {:ok, todo_list} ->
        {:reply, todo_list, todo_lists}

      :error ->
        todo_list = Todo.Server.start()
        todo_lists = Map.put(todo_lists, list_name, todo_list)
        {:reply, todo_list, todo_lists}
    end
  end

  @impl true
  def handle_call(_, _, todo_lists) do
    {:reply, :error, todo_lists}
  end
end
