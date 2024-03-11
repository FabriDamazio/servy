defmodule PledgeServerTest do
  use ExUnit.Case
  alias Servy.PledgeServer

  test "Cache 3 most recent pledges and sum all pledges" do
    PledgeServer.start()
    PledgeServer.create_pledge("Alice", 100)
    PledgeServer.create_pledge("Bob", 200)
    PledgeServer.create_pledge("Charlie", 300)

    assert PledgeServer.recent_pledges() == [
      {"Charlie", 300},
      {"Bob", 200},
      {"Alice", 100}
    ]

    assert PledgeServer.total_pledged() == 600

    PledgeServer.clear()
    assert PledgeServer.recent_pledges() == []
  end
end
