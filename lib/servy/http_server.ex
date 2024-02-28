defmodule Servy.HttpServer do

  def start(port) when is_integer(port) and port > 1023 do
    {:ok, listen_socket} = :gen_tcp.listen(port, [:binary, packet: :raw, active: false, reuseaddr: true])

    IO.puts("\n Listening requests on port #{port}...")

    accept_loop(listen_socket)
  end

  def accept_loop(listen_socket) do
    IO.puts("Waiting to accept for a client connection...\n")

    {:ok, client_socket} = :gen_tcp.accept(listen_socket)

    IO.puts("Connection accepted!\n")

    pid = spawn(fn -> serve(client_socket) end)
    :ok = :gen_tcp.controlling_process(client_socket, pid)

    accept_loop(listen_socket)
  end

  def serve(client_socket) do
    IO.puts("#{inspect(self())}")
    client_socket
    |> read_request
    |> generate_response
    |> write_response(client_socket)
  end

  defp read_request(client_socket) do
    {:ok, request} = :gen_tcp.recv(client_socket, 0)

    IO.puts("Received request:\n")
    IO.puts(request)

    request
  end

  def generate_response(request) do
    Servy.Handler.handle(request)
  end

  def write_response(response, client_socket) do
    :ok = :gen_tcp.send(client_socket, response)

    IO.puts("Response sent: \n")
    IO.puts(response)

    :gen_tcp.close(client_socket)
  end
end
