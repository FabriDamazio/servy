defmodule Servy.BearController do
  alias Servy.Bear
  alias Servy.Conv
  alias Servy.Wildthings

  def index(%Conv{} = conv) do
    items =
      Wildthings.list_bears()
      |> Enum.sort(&Bear.order_asc_by_name/2)
      |> Enum.map(&bear_item/1)
      |> Enum.join()

    %Conv{conv | status: 200, resp_body: "<ul>#{items}</ul>"}
  end

  def show(%Conv{} = conv, %{"id" => id}) do
    bear = Wildthings.get_bear(id)
    %Conv{conv | status: 200, resp_body: "<h1> Bear #{bear.id} - #{bear.name}</h1>"}
  end

  def create(%Conv{} = conv) do
    %Conv{
      conv
      | status: 201,
        resp_body: "Created a bear type #{conv.params["type"]} and name #{conv.params["name"]}!"
    }
  end

  def delete(%Conv{} = conv) do
    %Conv{conv | status: 403, resp_body: "Deleting a bear is forbidden!"}
  end

  defp bear_item(bear) do
    "<li>#{bear.name} - #{bear.type}</li>"
  end
end
