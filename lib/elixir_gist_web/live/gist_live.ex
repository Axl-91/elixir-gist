defmodule ElixirGistWeb.GistLive do
  alias ElixirGist.Gists
  use ElixirGistWeb, :live_view

  def mount(%{"id" => id}, _session, socket) do
    gist = Gists.get_gist!(id)

    socket =
      socket
      |> assign(gist: gist)

    {:ok, socket}
  end
end
