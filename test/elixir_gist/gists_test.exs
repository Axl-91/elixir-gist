defmodule ElixirGist.GistsTest do
  use ElixirGist.DataCase

  alias ElixirGist.Gists
  alias ElixirGist.Accounts
  alias ElixirGist.GistsFixtures
  import ElixirGist.AccountsFixtures

  describe "gists" do
    alias ElixirGist.Gists.Gist

    import ElixirGist.GistsFixtures

    @invalid_attrs %{name: nil, description: nil, markup_text: nil}

    test "list_gists/0 returns all gists" do
      gist = gist_fixture()
      assert Gists.list_gists() == [gist]
    end

    test "get_gist!/1 returns the gist with given id" do
      gist = gist_fixture()
      assert Gists.get_gist!(gist.id) == gist
    end

    test "create_gist/1 with valid data creates a gist" do
      {:ok, user} = Accounts.register_user(valid_user_attributes())

      valid_attrs = %{
        name: "some name",
        description: "some description",
        markup_text: "some markup_text"
      }

      assert {:ok, %Gist{} = gist} = Gists.create_gist(user, valid_attrs)
      assert gist.name == "some name"
      assert gist.description == "some description"
      assert gist.markup_text == "some markup_text"
    end

    test "create_gist/1 with invalid data returns error changeset" do
      {:ok, user} = Accounts.register_user(valid_user_attributes())

      assert {:error, %Ecto.Changeset{}} = Gists.create_gist(user, @invalid_attrs)
    end

    test "update_gist/2 with valid data updates the gist" do
      gist = gist_fixture()

      update_attrs = %{
        name: "some updated name",
        description: "some updated description",
        markup_text: "some updated markup_text"
      }

      assert {:ok, %Gist{} = gist} = Gists.update_gist(gist, update_attrs)
      assert gist.name == "some updated name"
      assert gist.description == "some updated description"
      assert gist.markup_text == "some updated markup_text"
    end

    test "update_gist/2 with invalid data returns error changeset" do
      gist = gist_fixture()
      assert {:error, %Ecto.Changeset{}} = Gists.update_gist(gist, @invalid_attrs)
      assert gist == Gists.get_gist!(gist.id)
    end

    test "delete_gist/1 deletes the gist" do
      gist = gist_fixture()
      assert {:ok, %Gist{}} = Gists.delete_gist(gist)
      assert_raise Ecto.NoResultsError, fn -> Gists.get_gist!(gist.id) end
    end

    test "change_gist/1 returns a gist changeset" do
      gist = gist_fixture()
      assert %Ecto.Changeset{} = Gists.change_gist(gist)
    end
  end

  describe "saved_gists" do
    alias ElixirGist.Gists.SavedGist

    import ElixirGist.GistsFixtures

    @invalid_attrs %{}

    test "list_saved_gists/0 returns all saved_gists" do
      saved_gist = saved_gist_fixture()
      assert Gists.list_saved_gists() == [saved_gist]
    end

    test "get_saved_gist!/1 returns the saved_gist with given id" do
      saved_gist = saved_gist_fixture()
      assert Gists.get_saved_gist!(saved_gist.id) == saved_gist
    end

    test "create_saved_gist/1 with valid data creates a saved_gist" do
      {:ok, user} = Accounts.register_user(valid_user_attributes())
      gist = GistsFixtures.gist_fixture()

      valid_attrs = %{gist_id: gist.id}

      assert {:ok, %SavedGist{}} = Gists.create_saved_gist(user, valid_attrs)
    end

    test "create_saved_gist/1 with invalid data returns error changeset" do
      {:ok, user} = Accounts.register_user(valid_user_attributes())

      assert {:error, %Ecto.Changeset{}} = Gists.create_saved_gist(user, @invalid_attrs)
    end

    test "update_saved_gist/2 with valid data updates the saved_gist" do
      saved_gist = saved_gist_fixture()
      update_attrs = %{}

      assert {:ok, %SavedGist{}} = Gists.update_saved_gist(saved_gist, update_attrs)
    end

    test "delete_saved_gist/1 deletes the saved_gist" do
      saved_gist = saved_gist_fixture()
      assert {:ok, %SavedGist{}} = Gists.delete_saved_gist(saved_gist)
      assert_raise Ecto.NoResultsError, fn -> Gists.get_saved_gist!(saved_gist.id) end
    end

    test "change_saved_gist/1 returns a saved_gist changeset" do
      saved_gist = saved_gist_fixture()
      assert %Ecto.Changeset{} = Gists.change_saved_gist(saved_gist)
    end
  end
end
