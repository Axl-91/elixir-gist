defmodule ElixirGistWeb.GistFormComponent do
  use ElixirGistWeb, :live_component

  alias ElixirGist.{Gists, Gists.Gist}

  def mount(socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
      <div>
        <.form
          for={@form}
          phx-submit="submit"
          phx-change="validate"
          phx-target={@myself}
        >
          <div class="justify-center px-28 w-full space-y-4 mb-10">
            <.input type="hidden" field={@form[:id]} value={@id} />
            <.input
                field={@form[:description]}
                placeholder="Gist description..."
                autocomplete="off"
                phx-debounce="blur"
            />
            <div>
                <div class="flex p-2 items-center bg-emDark rounded-t-md border">
                    <div class="w-[300px] mb-2">
                        <.input
                            field={@form[:name]}
                            placeholder="filename including extension..."
                            autocomplete="off"
                            phx-debounce="blur"
                        />
                    </div>
                </div>
                <div id="gist-wrapper" class="flex w-full" phx-update="ignore">
                    <textarea id="line-numbers" class="line-numbers rounded-bl-md" readonly>
                        <%= "1\n" %>
                    </textarea>
                    <div class="flex-grow">
                        <.input
                            id="gist-textarea"
                            type="textarea"
                            field={@form[:markup_text]}
                            class="textarea w-full rounded-br-md"
                            placeholder="Insert code..."
                            spellcheck="false"
                            autocomplete="off"
                            phx-hook="UpdateLineNumbers"
                            phx-debounce="blur"
                        />
                    </div>
                </div>
            </div>
            <div class="flex justify-end">
                <.button class="submit_button" phx-disable-with={if @id == :new, do: "Creating...", else: "Updating..."} >
                  <%= if @id == :new, do: "Create Gist", else: "Update Gist" %>
                </.button>
            </div>
          </div>
        </.form>
      </div>
    """
  end

  def handle_event("validate", %{"gist" => params}, socket) do
    gist_changeset =
      %Gist{}
      |> Gists.change_gist(params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, form: to_form(gist_changeset))}
  end

  def handle_event("submit", %{"gist" => %{"id" => "new"} = params}, socket),
    do: create_gist(socket, params)

  def handle_event("submit", %{"gist" => params}, socket), do: update_gist(socket, params)

  defp create_gist(socket, params) do
    case Gists.create_gist(socket.assigns.current_user, params) do
      {:ok, gist} ->
        socket =
          socket
          |> assign(form: to_form(Gists.change_gist(%Gist{})))
          |> push_event("clear-textarea", %{})
          |> push_navigate(to: ~p"/gist?#{[id: gist]}")

        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp update_gist(socket, params) do
    gist = Gists.get_gist!(params["id"])

    case Gists.update_gist(gist, params) do
      {:ok, gist} ->
        socket =
          socket
          |> push_navigate(to: ~p"/gist?#{[id: gist]}")

        {:noreply, socket}

      {:error, message} ->
        socket = put_flash(socket, :error, message)
        {:noreply, socket}
    end
  end
end
