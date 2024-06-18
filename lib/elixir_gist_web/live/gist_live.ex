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

  def handle_event("copy", _, socket) do
    socket =
      socket
      |> put_flash(:info, "Copied To Clipboard")

    {:noreply, socket}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    case Gists.delete_gist(socket.assigns.current_user, id) do
      {:ok, _gist} ->
        socket =
          socket
          |> put_flash(:info, "Gist Successfully Deleted")
          |> push_navigate(~p"/create")

        {:noreply, socket}

      {:error, message} ->
        socket =
          socket
          |> put_flash(:error, message)

        {:noreply, socket}
    end

    {:noreply, socket}
  end
end
