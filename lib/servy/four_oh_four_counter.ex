defmodule Servy.FourOhFourCounter do
  use GenServer
  require Logger
  @name :four_oh_four_counter

  def start_link(_arg) do
    Logger.info("Starting 404 Counter server...")
    GenServer.start_link(__MODULE__, %{}, name: @name)
  end

  def bump_count(path) do
    GenServer.call(@name, {:bump_count, path})
  end

  def get_count(path) do
    GenServer.call(@name, {:get_count, path})

  end

  def get_counts() do
    GenServer.call(@name, :get_counts)
  end

  def init(initial_state) do
    {:ok, initial_state}
  end

  def handle_call({:bump_count, path}, _from, state) do
    {:reply, :ok, Map.update(state, path, 1, &(&1 + 1))}
  end

  def handle_call({:get_count, path}, _from, state) do
    {:reply, Map.get(state, path, 0), state}
  end

  def handle_call(:get_counts, _from, state) do
    {:reply, state, state}
  end

  def handle_info(other, state) do
    IO.puts "Unexpected message: #{inspect other}"
    {:noreply, state}
  end
end
