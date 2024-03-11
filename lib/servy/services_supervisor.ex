defmodule Servy.ServicesSupervisor do
  use Supervisor
  require Logger

  def start_link(_arg) do
    Logger.info("Starting Services Supervisor...")
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    children = [
      Servy.PledgeServer,
      {Servy.SensorServer, 60000},
      Servy.FourOhFourCounter
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
