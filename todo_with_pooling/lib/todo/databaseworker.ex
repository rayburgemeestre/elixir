defmodule Todo.DatabaseWorker do
  use GenServer

  def start(db_file) do
    IO.puts("starting with db file: #{db_file}")
    {:ok, pid} = GenServer.start(__MODULE__, db_file)
    pid
  end

  @impl true
  def init(db_file) do
    File.mkdir_p!(db_file)
    {:ok, db_file}
  end

  def save(pid, list_name, list) do
    GenServer.cast(pid, {:save, list_name, list})
  end

  def read(pid, list_name) do
    GenServer.call(pid, {:read, list_name})
  end

  @impl true
  def handle_cast({:save, list_name, list}, db_file) do
    Path.join(db_file, list_name)
    |> File.write!(:erlang.term_to_binary(list))

    {:noreply, db_file}
  end

  @impl true
  def handle_call({:read, list_name}, _, db_file) do
    filename = Path.join(db_file, list_name)

    list =
      case File.read(filename) do
        {:ok, contents} ->
          :erlang.binary_to_term(contents)

        _ ->
          nil
      end

    {:reply, list, db_file}
  end
end
