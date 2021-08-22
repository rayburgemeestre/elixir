defmodule Todo.Database do
  use GenServer

  @db_file "./persist"

  def start do
    {:ok, pid} = GenServer.start(__MODULE__, %{}, name: __MODULE__)
    pid
  end

  @impl true
  def init(_) do
    File.mkdir_p!(@db_file)
    {:ok, nil}
  end

  def save(list_name, list) do
    GenServer.cast(__MODULE__, {:save, list_name, list})
  end

  def read(list_name) do
    GenServer.call(__MODULE__, {:read, list_name})
  end

  @impl true
  def handle_cast({:save, list_name, list}, cache) do
    Path.join(@db_file, list_name)
    |> File.write!(:erlang.term_to_binary(list))
    {:noreply, cache}
  end

  @impl true
  def handle_call({:read, list_name}, _, cache) do
    filename =
      Path.join(@db_file, list_name)
    list = case File.read(filename) do
      {:ok, contents} ->
        :erlang.binary_to_term(contents)
      _ ->
        nil
    end
    {:reply, list, cache}
  end
end
