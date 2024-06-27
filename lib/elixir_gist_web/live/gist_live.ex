defmodule ElixirGistWeb.GistLive do
  use ElixirGistWeb, :live_view

  alias ElixirGist.Gists
  alias ElixirGistWeb.GistFormComponent

  def mount(%{"id" => id}, _session, socket) do
    gist = Gists.get_gist!(id)

    {:ok, last_updated_time} =
      Timex.format(gist.updated_at, "{relative}", :relative)

    gist =
      Map.put(gist, :last_updated_time, last_updated_time)

    socket =
      socket
      |> assign(gist: gist)
      |> assign(form: to_form(Gists.change_gist(gist)))

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
          |> push_navigate(to: ~p"/create")

        {:noreply, socket}

      {:error, message} ->
        socket =
          socket
          |> put_flash(:error, message)

        {:noreply, socket}
    end
  end
end
