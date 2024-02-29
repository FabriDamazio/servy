defmodule Servy.Api.BearController do
  def index(conv) do
    json =
      Servy.Wildthings.list_bears()
      |> Poison.encode!()

    updated_resp_headers = Map.put(conv.resp_headers, "Content-Type", "application/json")

    %{conv | status: 200, resp_body: json, resp_headers: updated_resp_headers}
  end

  def create(conv) do
    %{
      conv
      | status: 201,
        resp_body: "Created a #{conv.params["type"]} bear named #{conv.params["name"]}!"
    }
  end
end
