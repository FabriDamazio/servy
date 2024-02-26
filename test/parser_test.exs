defmodule ParserTest do
  use ExUnit.Case
  doctest Servy.Parser

  alias Servy.Parser
  alias Servy.Conv

  test "Parse request without body" do
    request = """
    GET /wildthings HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    expected_result = %Conv{
      method: "GET",
      path: "/wildthings",
      params: %{},
      headers: %{"Host" => "example.com", "User-Agent" => "ExampleBrowser/1.0", "Accept" => "*/*"}
    }

    assert expected_result == Parser.parse(request)
  end

  test "Parse request with body" do
    request = """
    POST /bears HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    Content-Type: application/x-www-form-urlencoded\r
    Content-Length: 21\r
    \r
    name=Baloo&type=Brown
    """

    expected_result = %Conv{
      method: "POST",
      path: "/bears",
      params: %{"name" => "Baloo", "type" => "Brown"},
      headers: %{
        "Host" => "example.com",
        "User-Agent" => "ExampleBrowser/1.0",
        "Accept" => "*/*",
        "Content-Type" => "application/x-www-form-urlencoded",
        "Content-Length" => "21"
      }
    }

    assert expected_result == Parser.parse(request)
  end
end
