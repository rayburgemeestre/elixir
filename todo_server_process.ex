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

defmodule ServerProcess do
  def start(callback_module) do
    spawn(fn ->
      initial_state = callback_module.init()
      loop(callback_module, initial_state)
    end)
  end

  def loop(callback_module, current_state) do
    receive do
      {:call, request, caller} ->
        {response, new_state} = callback_module.handle_call(request, current_state)
        send(caller, {:response, response})
        loop(callback_module, new_state)

      {:cast, request} ->
        new_state = callback_module.handle_cast(request, current_state)
        loop(callback_module, new_state)
    after
      500 ->
        {:error, :timeout}
    end
  end

  def call(server_pid, request) do
    send(server_pid, {:call, request, self()})

    receive do
      {:response, response} -> response
    after
      500 -> {:error, :timeout2}
    end
  end

  def cast(server_pid, request) do
    send(server_pid, {:cast, request})
  end
end

defmodule TodoList.TodoServer do
  def start do
    # Below doesn't work because now ServerProcess is a different process??
    # I don't know actually...
    # Process.register(
    #   ServerProcess.start(TodoList.TodoServer),
    #   :todo_server
    # )
    # For now I'm not going to continue spending time on it, and continue with passing along the server pid everywhere
    ServerProcess.start(TodoList.TodoServer)
  end

  def init, do: TodoList.new()

  def add_entry(todo_server, new_entry) do
    ServerProcess.cast(todo_server, {:add_entry, new_entry})
  end

  def entries(todo_server, date) do
    ServerProcess.call(todo_server, {:entries, self(), date})
  end

  def handle_cast({:add_entry, new_entry}, todo_list) do
    TodoList.add_entry(todo_list, new_entry)
  end

  def handle_call({:entries, sender, date}, todo_list) do
    entries = send(sender, {:todo_entries, TodoList.entries(todo_list, date)})
    {entries, todo_list}
  end

  def handle_call(_, todo_list) do
    {:error, todo_list}
  end
end

defmodule TodoList.Main do
  def run() do
    pid = TodoList.TodoServer.start()
    TodoList.TodoServer.add_entry(pid, %{date: ~D[2018-12-19], title: "Dentist"})
    TodoList.TodoServer.add_entry(pid, %{date: ~D[2018-12-20], title: "Shopping"})
    TodoList.TodoServer.add_entry(pid, %{date: ~D[2018-12-19], title: "Movies"})
    TodoList.TodoServer.entries(pid, ~D[2018-12-19])
  end
end
