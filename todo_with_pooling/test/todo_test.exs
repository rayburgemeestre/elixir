defmodule TodoTest do
  use ExUnit.Case

  #  test "test" do
  #    IO.inspect(File.rm("./persist/ray"))
  #
  #    Todo.Cache.start()
  #
  #    pid = Todo.Cache.get("ray")
  #    Todo.Server.add_entry(pid, %{date: ~D[2018-12-19], title: "Dentist"})
  #    Todo.Server.add_entry(pid, %{date: ~D[2018-12-20], title: "Shopping"})
  #    Todo.Server.add_entry(pid, %{date: ~D[2018-12-19], title: "Movies"})
  #    entries = Todo.Server.entries(pid, ~D[2018-12-19])
  #
  #    assert entries ==
  #             {:todo_entries,
  #              [
  #                {1, %{date: ~D[2018-12-19], id: 1, title: "Dentist"}},
  #                {3, %{date: ~D[2018-12-19], id: 3, title: "Movies"}}
  #              ]}
  #  end

  test "test 2" do
    Todo.Cache.start()

    pid = Todo.Cache.get("ray")
    entries = Todo.Server.entries(pid, ~D[2018-12-19])

    assert entries ==
             {:todo_entries,
              [
                {1, %{date: ~D[2018-12-19], id: 1, title: "Dentist"}},
                {3, %{date: ~D[2018-12-19], id: 3, title: "Movies"}}
              ]}
  end
end
