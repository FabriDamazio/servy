defmodule Servy.Emojifier do
  def emojify(%{status: 200} = conv) do
    emojies = String.duplicate("🎉", 5)
    %{conv | resp_body: emojies <> "\n" <> conv.resp_body <> "\n" <> emojies}
  end

  def emojify(conv), do: conv
end
