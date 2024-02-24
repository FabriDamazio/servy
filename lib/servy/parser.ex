defmodule Servy.Parser do
  alias Servy.Conv

  def parse(request) do
    [top, body] = String.split(request, "\n\n")
    [request_info | _headers] = String.split(top, "\n")
    [method, path, _protocol] = String.split(request_info, " ")
    params = decode_query_params(body)

    %Conv{method: method, path: path, params: params}
  end

  defp decode_query_params(params) do
    params |> String.trim() |> URI.decode_query()
  end
end
