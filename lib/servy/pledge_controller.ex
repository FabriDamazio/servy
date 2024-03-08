defmodule Servy.PledgeController do
  alias Servy.PledgesView

  def create(conv, %{"name" => name, "amount" => amount}) do
    # Sends the pledge to the external service and caches it
    Servy.PledgeServer.create_pledge(name, String.to_integer(amount))

    %{conv | status: 201, resp_body: "#{name} pledged #{amount}!"}
  end

  def new(conv) do
    %{conv | status: 200, resp_body: PledgesView.new()}
  end

  def index(conv) do
    # Gets the recent pledges from the cache
    pledges = Servy.PledgeServer.recent_pledges()

    %{conv | status: 200, resp_body: PledgesView.recent(pledges)}
  end

  def total(conv) do
    # Gets the total pledges
    total = Servy.PledgeServer.total_pledges()

    %{conv | status: 200, resp_body: inspect(total)}
  end
end
