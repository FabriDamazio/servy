defmodule Servy do
  use Application
  require Logger

  def start(_type, _args) do
    Logger.info("Starting Servy Application...")
    Servy.Supervisor.start_link()
  end
end
