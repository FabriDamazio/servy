defmodule Servy.Parser do
  alias Servy.Conv

  def parse(request) do
    [top, body] = String.split(request, "\n\n")
    [request_info | headers] = String.split(top, "\n")
    [method, path, _protocol] = String.split(request_info, " ")

    headers = parse_headers(headers, %{})
    params = decode_query_params(headers["content-type"], body)

    %Conv{method: method, path: path, params: params, headers: headers}
  end

  defp parse_headers([head | tail], headers) do
    [key, value] = String.split(head, ": ")
    headers = Map.put(headers, key, value)

    parse_headers(tail, headers)
  end

  defp parse_headers([], headers), do: headers

  defp decode_query_params("application/x-www-form-urlencoded", params) do
    params |> String.trim() |> URI.decode_query()
  end

  defp decode_query_params(_, _), do: %{}
end
