defmodule Servy.Handler do
  import Servy.Parser, only: [parse: 1]
  import Servy.Plugins, only: [rewrite_path: 1, log: 1, track: 1]
  import Servy.FileHandler, only: [handle_file: 2]
  alias Servy.Conv

  @pages_path Path.expand("../../pages", File.cwd!())

  def handle(request) do
    request
    |> parse()
    |> rewrite_path()
    |> log()
    |> route()
    |> track()
    |> format_response()
  end

  def route(%Conv{method: "GET", path: "/about"} = conv) do
    @pages_path
    |> Path.join("about.html")
    |> File.read()
    |> handle_file(conv)
  end

  def route(%Conv{method: "GET", path: "/bears/new"} = conv) do
    @pages_path
    |> Path.join("form.html")
    |> File.read()
    |> handle_file(conv)
  end

  def route(%Conv{method: "GET", path: "/pages/" <> file} = conv) do
    @pages_path
    |> Path.join(file <> ".html")
    |> File.read()
    |> handle_file(conv)
  end

  def route(%Conv{method: "GET", path: "/wildthings"} = conv) do
    %{conv | status: 200, resp_body: "Bears, Lions, Tigers"}
  end

  def route(%Conv{method: "GET", path: "/bears"} = conv) do
    %{conv | status: 200, resp_body: "Teddy, Smokey, Paddington"}
  end

  def route(%Conv{method: "GET", path: "/bears/" <> id} = conv) do
    %{conv | status: 200, resp_body: "Bear #{id}"}
  end

  def route(%Conv{method: "DELETE", path: "/bears/" <> _id} = conv) do
    %{conv | status: 403, resp_body: "Deleting a bear is forbidden!"}
  end

  def route(%Conv{method: "POST", path: "/bears"} = conv) do
    %{
      conv
      | status: 201,
        resp_body: "Created a #{conv.params["type"]} bear named #{conv.params["name"]}"
    }
  end

  def route(%Conv{} = conv) do
    %{conv | status: 404, resp_body: "No #{conv.path} here!"}
  end

  def format_response(%Conv{} = conv) do
    """
    HTTP/1.1 #{Conv.full_status(conv)}
    Content-Type: text/html
    Content-Length: #{byte_size(conv.resp_body)}

    #{conv.resp_body}
    """
  end
end

request = """
GET /about HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)
IO.puts(response)

request = """
GET /bears?id=1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)
IO.puts(response)

request = """
POST /bears HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*
Content-Type: application/x-www-form-urlencoded
Content-Length: 21

name=Baloo&type=Brown
"""

response = Servy.Handler.handle(request)

IO.puts(response)
