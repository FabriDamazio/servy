defmodule Servy.Fetcher do
  def async(fun) do
    caller = self()
    spawn(fn -> send(caller, {self(), :result, fun.()}) end)
  end

  def get_result(caller_pid) do
    receive do
      {^caller_pid, :result, value} -> value
    end
  end
end
