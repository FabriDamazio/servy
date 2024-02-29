defmodule Servy.VideoCam do
  def get_snapshot(caller_pid, camera_name) do
    :timer.sleep(1000)
    send(caller_pid, {:result, "#{camera_name}snapshot.jpg"})
  end
end
