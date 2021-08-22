defmodule Todo.Main do
  def run do
# pid = Todo.Server.start()
# Todo.Server.add_entry(pid, %{date: ~D[2018-12-19], title: "Dentist"})
# Todo.Server.add_entry(pid, %{date: ~D[2018-12-20], title: "Shopping"})
# Todo.Server.add_entry(pid, %{date: ~D[2018-12-19], title: "Movies"})
# entries = Todo.Server.entries(pid, ~D[2018-12-19])
#
# pid = Todo.Database.start()
# Todo.Database.save(pid, "ray", entries)
# IO.inspect(Todo.Database.read(pid, "ray"))

    cache = Todo.Cache.start()
    pid = Todo.Cache.get(cache, "ray")
# Todo.Server.add_entry(pid, %{date: ~D[2018-12-19], title: "Dentist"})
# Todo.Server.add_entry(pid, %{date: ~D[2018-12-20], title: "Shopping"})
# Todo.Server.add_entry(pid, %{date: ~D[2018-12-19], title: "Movies"})
    entries = Todo.Server.entries(pid, ~D[2018-12-19])
  end
end