defmodule Servy.FourOhFourCounter do
  @name :four_oh_four_counter

  alias Servy.PledgeServerManualGenserver.GenericServer

  def start() do
    GenericServer.start(__MODULE__, %{}, @name)
  end

  def bump_count(path) do
    GenericServer.call(@name, {:bump_count, path})
  end

  def get_count(path) do
    GenericServer.call(@name, {:get_count, path})

  end

  def get_counts() do
    GenericServer.call(@name, :get_counts)
  end

  def handle_call({:bump_count, path}, state) do
    {:ok, Map.update(state, path, 1, &(&1 + 1))}
  end

  def handle_call({:get_count, path}, state) do
    {Map.get(state, path, 0), state}
  end

  def handle_call(:get_counts, state) do
    {state, state}
  end

  def handle_info(other, state) do
    IO.puts "Unexpected message: #{inspect other}"
    state
  end
end
