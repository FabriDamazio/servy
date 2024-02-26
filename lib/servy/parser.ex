defmodule Servy.Parser do
  alias Servy.Conv

  def parse(request) do
    [top, body] = String.split(request, "\r\n\r\n")
    [request_info | headers] = String.split(top, "\r\n")
    [method, path, _protocol] = String.split(request_info, " ")

    headers = parse_headers(headers)
    params = decode_query_params(headers["Content-Type"], body)

    %Conv{method: method, path: path, params: params, headers: headers}
  end

  @doc """
  Parses the headers from a request into a map with corresponding keys and values.

  ## Examples
        iex> Servy.Parser.parse_headers(["Host: example.com", "User-Agent: ExampleBrowser/1.0"])
        %{"Host" => "example.com", "User-Agent" => "ExampleBrowser/1.0"}
  """
  def parse_headers(header_lines) do
    Enum.reduce(header_lines, %{}, fn line, acc ->
      [key, value] = String.split(line, ": ")
      Map.put(acc, key, value)
    end)
  end

  # Recursion version just for study purposes
  # defp parse_headers([head | tail], headers) do
  #   [key, value] = String.split(head, ": ")
  #   headers = Map.put(headers, key, value)

  #   parse_headers(tail, headers)
  # end

  # defp parse_headers([], headers), do: headers

  defp decode_query_params("application/x-www-form-urlencoded", params) do
    params |> String.trim() |> URI.decode_query()
  end

  defp decode_query_params(_, _), do: %{}
end
