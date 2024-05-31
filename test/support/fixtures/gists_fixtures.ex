defmodule ElixirGist.GistsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ElixirGist.Gists` context.
  """
  import ElixirGist.AccountsFixtures
  alias ElixirGist.Accounts

  @doc """
  Generate a gist.
  """
  def gist_fixture(attrs \\ %{}) do
    {:ok, user} =
      case Map.get(attrs, :user_id) do
        nil ->
          Accounts.register_user(valid_user_attributes())

        id ->
          {:ok, Accounts.get_user!(id)}
      end

    attrs =
      attrs
      |> Enum.into(%{
        description: "some description",
        markup_text: "some markup_text",
        name: "some name"
      })

    {:ok, gist} = ElixirGist.Gists.create_gist(user, attrs)

    gist
  end

  @doc """
  Generate a saved_gist.
  """
  def saved_gist_fixture(attrs \\ %{}) do
    {:ok, user} =
      case Map.get(attrs, :user_id) do
        nil ->
          Accounts.register_user(valid_user_attributes())

        id ->
          Accounts.get_user!(id)
      end

    gist = gist_fixture(%{user_id: user.id})

    {:ok, saved_gist} =
      ElixirGist.Gists.create_saved_gist(user, %{gist_id: gist.id})

    saved_gist
  end
end
