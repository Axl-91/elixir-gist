defmodule ElixirGist.CommentsFixtures do
  import ElixirGist.AccountsFixtures
  import ElixirGist.GistsFixtures
  alias ElixirGist.Accounts

  @moduledoc """
  This module defines test helpers for creating
  entities via the `ElixirGist.Comments` context.
  """

  @doc """
  Generate a comment.
  """
  def comment_fixture(attrs \\ %{}) do
    {:ok, user} =
      case Map.get(attrs, :user_id) do
        nil ->
          Accounts.register_user(valid_user_attributes())

        id ->
          Accounts.get_user!(id)
      end

    gist = gist_fixture(%{user_id: user.id})

    attrs =
      attrs
      |> Enum.into(%{markup_text: "some markup_text", gist_id: gist.id})

    {:ok, comment} =
      ElixirGist.Comments.create_comment(user, attrs)

    comment
  end
end
