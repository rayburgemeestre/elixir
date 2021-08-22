defmodule TodoTest do
  use ExUnit.Case

  test "test" do
    IO.inspect(File.rm("./persist/ray"))

    _ = Todo.Database.start()
    pid = Todo.Server.start("ray")
    Todo.Server.add_entry(pid, %{date: ~D[2018-12-19], title: "Dentist"})
    Todo.Server.add_entry(pid, %{date: ~D[2018-12-20], title: "Shopping"})
    Todo.Server.add_entry(pid, %{date: ~D[2018-12-19], title: "Movies"})
    entries = Todo.Server.entries(pid, ~D[2018-12-19])

    assert entries ==
             {:todo_entries,
              [
                {1, %{date: ~D[2018-12-19], id: 1, title: "Dentist"}},
                {3, %{date: ~D[2018-12-19], id: 3, title: "Movies"}}
              ]}
  end

#  test "test2" do
#    File.rm("./persist/alice")
#    File.rm("./persist/bob")
#
#   # _ = Todo.Database.start()
#    cache = Todo.Cache.start()
#
#    alice = Todo.Cache.get(cache, :alice)
#    Todo.Server.add_entry(alice, %{date: ~D[2018-12-19], title: "Shopping"})
#    Todo.Server.add_entry(alice, %{date: ~D[2018-12-20], title: "Cooking"})
#    Todo.Server.add_entry(alice, %{date: ~D[2018-12-19], title: "Skateboarding"})
#
#    bob = Todo.Cache.get(cache, :bob)
#    Todo.Server.add_entry(bob, %{date: ~D[2018-12-19], title: "Nothing"})
#    Todo.Server.add_entry(bob, %{date: ~D[2018-12-20], title: "Eating"})
#
#    assert {:todo_entries,
#            [
#              {1, %{date: ~D[2018-12-19], id: 1, title: "Shopping"}},
#              {3, %{date: ~D[2018-12-19], id: 3, title: "Skateboarding"}}
#            ]} == Todo.Server.entries(alice, ~D[2018-12-19])
#
#    alice = Todo.Cache.get(cache, :alice)
#
#    assert {:todo_entries,
#            [
#              {1, %{date: ~D[2018-12-19], id: 1, title: "Shopping"}},
#              {3, %{date: ~D[2018-12-19], id: 3, title: "Skateboarding"}}
#            ]} == Todo.Server.entries(alice, ~D[2018-12-19])
#
#    assert {:todo_entries, [{1, %{date: ~D[2018-12-19], id: 1, title: "Nothing"}}]} ==
#             Todo.Server.entries(bob, ~D[2018-12-19])
#  end
#
#  test "database" do
#    pid = Todo.Server.start(:ray)
#    Todo.Server.add_entry(pid, %{date: ~D[2018-12-19], title: "Dentist"})
#    Todo.Server.add_entry(pid, %{date: ~D[2018-12-20], title: "Shopping"})
#    Todo.Server.add_entry(pid, %{date: ~D[2018-12-19], title: "Movies"})
#    entries = Todo.Server.entries(pid, ~D[2018-12-19])
#
#    Todo.Database.start()
#    entries2 = Todo.Database.read("ray")
#    assert entries == entries2
#  end
end
