defmodule Servy.Handler do
  require Logger

  def handle(request) do
    request
    |> parse()
    |> rewrite_path()
    |> log()
    |> route()
    |> track()
    |> emojify()
    |> format_response()
  end

  def rewrite_path(%{path: path} = conv) do
    regex = ~r{\/(?<thing>\w+)\?id=(?<id>\d+)}
    captures = Regex.named_captures(regex, path)
    rewrite_path_captures(conv, captures)
  end

  def rewrite_path_captures(conv, %{"thing" => thing, "id" => id}) do
    %{ conv | path: "/#{thing}/#{id}" }
  end

  def rewrite_path_captures(conv, nil), do: conv

  def log(conv), do: IO.inspect(conv)

  def parse(request) do
    [method, path, _version] =
      request
      |> String.split("\n")
      |> List.first()
      |> String.split()

    %{method: method, path: path, resp_body: "", status: nil}
  end

  def track(%{status: 404, path: path} = conv) do
    Logger.warn("Waning: #{path} is on the loose!")
    conv
  end

  def track(conv), do: conv

  def route(%{method: "GET", path: "/wildthings"} = conv) do
    %{conv | status: 200, resp_body: "Bears, Lions, Tigers"}
  end

  def route(%{method: "GET", path: "/bears"} = conv) do
    %{conv | status: 200, resp_body: "Teddy, Smokey, Paddington"}
  end

  def route(%{method: "GET", path: "/bears/" <> id} = conv) do
    %{conv | status: 200, resp_body: "Bear #{id}"}
  end

  def route(%{method: "DELETE", path: "/bears/" <> _id} = conv) do
    %{conv | status: 403, resp_body: "Deleting bear is forbidden!"}
  end

  def route(%{path: path} = conv) do
    %{conv | status: 404, resp_body: "No #{path} here!"}
  end

  def emojify(%{status: 200} = conv) do
    emojies = String.duplicate("🎉", 5)
    body = emojies <> "\n" <> conv.resp_body <> "\n" <> emojies

    %{ conv | resp_body: body }
  end

  def emojify(conv), do: conv

  def format_response(conv) do
    """
      HTTP/1.1 #{conv.status} #{status_reason(conv.status)}
      Content-Type: text/html
      Content-Length: #{byte_size(conv.resp_body)}

      #{conv.resp_body}
    """
  end

  defp status_reason(code) do
    codes = %{
      200 => "OK",
      201 => "Created",
      401 => "Unauthorized",
      403 => "Forbidden",
      404 => "Not Found",
      500 => "Internal Server Error"
    }

    codes[code]
  end
end

# request = """
# GET /wildthings HTTP/1.1
# Host: example.com
# User-Agent: ExampleBrowser/1.0
# Accept: */*

# """

# response = Servy.Handler.handle(request)
# IO.puts(response)
