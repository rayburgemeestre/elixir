defmodule Todo.Database do
  use GenServer

  @db_file "./persist"

  def start do
    {:ok, pid} = GenServer.start(__MODULE__, %{}, name: __MODULE__)
    pid
  end

  @impl true
  def init(state) do
    File.mkdir_p!(@db_file)
    {:ok, start_workers()}
  end

  # peeked at author's solution
  defp start_workers() do
    for index <- 0..2, into: %{} do
      pid = Todo.DatabaseWorker.start(@db_file)
      {index, pid}
    end
  end

  def choose_worker(list_name) do
    GenServer.call(__MODULE__, {:choose_worker, list_name})
  end

  def save(list_name, list) do
    choose_worker(list_name)
    |> Todo.DatabaseWorker.save(list_name, list)
  end

  def read(list_name) do
    choose_worker(list_name)
    |> Todo.DatabaseWorker.read(a, list_name)
  end

  @impl true
  def handle_call({:choose_worker, list_name}, _, state) do
    index = :erlang.phash2(list_name, 3)
    worker = Map.get(state, index)
    {:reply, worker, state}
  end
end
