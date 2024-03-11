defmodule Servy.PledgeServer do
  require Logger
  use GenServer

  @name :pledge_server

  defmodule State do
    defstruct cache_size: 3, pledges: []
  end

  # Client interface functions

  def start_link(_arg) do
    Logger.info("Starting Pledge Server...")
    GenServer.start_link(__MODULE__, %State{}, name: @name)
  end

  def set_cache_size(size) do
    GenServer.cast(@name, {:set_cache_size, size})
  end

  def create_pledge(name, amount) do
    GenServer.call(@name, {:create_pledge, name, amount})
  end

  def recent_pledges() do
    GenServer.call(@name, :recent_pledges)
  end

  def total_pledged() do
    GenServer.call(@name, :total_pledged)
  end

  def clear do
    GenServer.cast(@name, :clear)
  end

  # Server Callbacks

  def init(state) do
    {:ok, initial_state} = fetch_recent_pledges_from_service()
    {:ok, %{state | pledges: initial_state}}
  end

  def handle_call(:total_pledged, _from, state) do
    total = Enum.reduce(state.pledges, 0, fn {_, amount}, acc -> acc + amount end)
    {:reply, total, state}
  end

  def handle_call(:recent_pledges, _from, state) do
    {:reply, state.pledges, state}
  end

  def handle_call({:create_pledge, name, amount}, _from, state) do
    {:ok, id} = send_pledge_to_service(name, amount)
    most_recent_pledges = state.pledges |> Enum.take(state.cache_size - 1)
    cached_pledges = [{name, amount} | most_recent_pledges]
    new_state = %{state | pledges: cached_pledges}
    {:reply, id, new_state}
  end

  def handle_cast(:clear, state) do
    {:noreply, %{state | pledges: []}}
  end

  def handle_cast({:set_cache_size, size}, state) do
    new_state = %{state | cache_size: size}
    {:noreply, new_state}
  end

  def handle_info(msg, state) do
    Logger.info("Received unexpected message: #{inspect(msg)}")
    {:noreply, state}
  end

  defp send_pledge_to_service(_name, _amount) do
    # STUB: This would send the pledge to an external service
    {:ok, "pledge-#{:rand.uniform(1000)}"}
  end

  defp fetch_recent_pledges_from_service() do
    # STUB: This would fetch the pledges from an external service
    {:ok, [{"wilma", 15}, {"fred", 25}]}
  end
end
