defmodule Servy.FileHandler do
  alias Servy.Conv

  def handle_file(result, %Conv{} = conv) do
    case result do
      {:ok, content} -> %{conv | status: 200, resp_body: content}
      {:error, :enoent} -> %{conv | status: 404, resp_body: "File not found!"}
      {:error, reason} -> %{conv | status: 500, resp_body: "File error: #{reason}"}
    end
  end
end
