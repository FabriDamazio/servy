defmodule Servy.PledgeServer do
  @name :pledge_server

  # Client interface functions

  def start() do
    pid = spawn(__MODULE__, :listen_loop, [[]])
    Process.register(pid, @name)
    {:ok, pid}
  end

  def create_pledge(name, amount) do
    send(@name, {self(), :create_pledge, name, amount})

    receive do
      {:response, status} -> status
    end
  end

  def recent_pledges() do
    send(@name, {self(), :recent_pledges})

    receive do
      {:response, pledges} -> pledges
    end
  end

  def total_pledges() do
    send(@name, {self(), :total_pledges})

    receive do
      {:response, total} -> total
    end
  end

  # Server functions

  def listen_loop(state) do
    IO.puts("Waiting for a message")

    receive do
      {sender, :create_pledge, name, amount} ->
        {:ok, id} = send_pledge_to_service(name, amount)
        most_recent_pledges = state |> Enum.take(2)
        new_state = [{name, amount} | most_recent_pledges]
        send(sender, {:response, id})
        listen_loop(new_state)

      {sender, :recent_pledges} ->
        send(sender, {:response, state})
        listen_loop(state)

      {sender, :total_pledges} ->
        total = Enum.reduce(state, 0, fn {_, amount}, acc -> acc + amount end)
        send(sender, {:response, total})
        listen_loop(state)

      unexpected ->
        IO.puts("Unexpected message: #{inspect(unexpected)}")
        listen_loop(state)
    end
  end

  defp send_pledge_to_service(_name, _amount) do
    # STUB: This would send the pledge to an external service
    {:ok, "pledge-#{:rand.uniform(1000)}"}
  end
end

# alias Servy.PledgeServer

# PledgeServer.start()

# IO.inspect PledgeServer.create_pledge("larry", 10)
# IO.inspect PledgeServer.create_pledge("moe", 20)
# IO.inspect PledgeServer.create_pledge("curly", 30)
# IO.inspect PledgeServer.create_pledge("daisy", 40)
# IO.inspect PledgeServer.create_pledge("grace", 50)
# IO.inspect PledgeServer.recent_pledges()