defmodule Servy.Supervisor do
  use Supervisor
  require Logger

  def start_link do
    Logger.info("Starting Top Level Supervisor...")
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    children = [
      Servy.KickStarter,
      Servy.ServicesSupervisor,
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
