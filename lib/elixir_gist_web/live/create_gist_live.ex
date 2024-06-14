defmodule ElixirGistWeb.CreateGistLive do
  alias ElixirGist.Gists
  alias ElixirGist.Gists.Gist
  use ElixirGistWeb, :live_view

  def mount(_params, _session, socket) do
    socket = socket_with_new_gist_form(socket)

    {:ok, socket}
  end

  def handle_event("validate", %{"gist" => params}, socket) do
    gist_changeset =
      %Gist{}
      |> Gists.change_gist(params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, form: to_form(gist_changeset))}
  end

  def handle_event("create", %{"gist" => params}, socket) do
    case Gists.create_gist(socket.assigns.current_user, params) do
      {:ok, _gist} ->
        socket = socket_with_new_gist_form(socket)
        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp socket_with_new_gist_form(socket) do
    gist_changeset = Gists.change_gist(%Gist{})
    assign(socket, form: to_form(gist_changeset))
  end
end
