defmodule Servy.KickStarter do
  use GenServer
  require Logger

  def start_link(_arg) do
    Logger.info("Starting the Kickstarter...")
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def get_server do
    GenServer.call __MODULE__, :get_server
  end

  def init(:ok) do
    Process.flag(:trap_exit, true)
    Logger.info("Starting HTTP Sever...")
    server_pid = start_http_server()
    {:ok, server_pid}
  end

  def handle_info({:EXIT, _pid, reason}, _state) do
    Logger.error("HTTP Server exited with reason: #{inspect reason}")
    server_pid = start_http_server()
    {:noreply, server_pid}
  end

  def handle_call(:get_server, _from, state) do
    {:reply, state, state}
  end

  defp start_http_server() do
    port = Application.get_env(:servy, :port)
    server_pid = spawn_link(Servy.HttpServer, :start, [port])
    Process.register(server_pid, :http_server)
    server_pid
  end
end
