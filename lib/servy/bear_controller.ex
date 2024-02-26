defmodule Servy.BearController do
  alias Servy.BearView
  alias Servy.Bear
  alias Servy.Conv
  alias Servy.Wildthings
  require BearView

  def index(%Conv{} = conv) do
    bears =
      Wildthings.list_bears()
      |> Enum.sort(&Bear.order_asc_by_name/2)

    %Conv{conv | status: 200, resp_body: BearView.index(bears)}
  end

  def show(%Conv{} = conv, %{"id" => id}) do
    bear = Wildthings.get_bear(id)

    %Conv{conv | status: 200, resp_body: BearView.show(bear)}
  end

  def create(%Conv{} = conv) do
    %Conv{
      conv
      | status: 201,
        resp_body: "Created a #{conv.params["type"]} bear named #{conv.params["name"]}!"
    }
  end

  def delete(%Conv{} = conv) do
    %Conv{conv | status: 403, resp_body: "Deleting a bear is forbidden!"}
  end
end
