defmodule Servy.ResponseFormatter do
  alias Servy.Conv

  def format_response(%Conv{} = conv) do
    """
    HTTP/1.1 #{Conv.full_status(conv)}\r
    #{format_response_headers(conv.resp_headers)}
    \r
    #{conv.resp_body}
    """
  end

  defp format_response_headers(resp_headers) do
    Enum.map(resp_headers, fn {key, value} ->
      "#{key}: #{value}\r"
    end)
    |> Enum.sort()
    |> Enum.reverse()
    |> Enum.join("\n")
  end
end
