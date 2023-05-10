defmodule Blog.PostsTest do
  use Blog.DataCase

  alias Blog.Posts
  alias Blog.Comments

  describe "posts" do
    alias Blog.Posts.Post

    import Blog.PostsFixtures
    import Blog.CommentsFixtures

    @invalid_attrs %{content: nil, subtitle: nil, title: nil}

    test "list_posts/0 returns all posts" do
      post = post_fixture()
      assert Posts.list_posts() == [post]
    end

    test "list_posts/1 filters posts by title" do
      post = post_fixture(title: "Title")
      assert Posts.list_posts("Non-Matching") == []
      assert Posts.list_posts("Title") == [post]
      assert Posts.list_posts("") == [post]
      assert Posts.list_posts("title") == [post]
      assert Posts.list_posts("itl") == [post]
      assert Posts.list_posts("ITL") == [post]
    end

    test "get_post!/1 returns the post with given id" do
      post = post_fixture()
      assert Posts.get_post!(post.id) == Repo.preload(post, :comments)
    end

    test "create_post/1 with valid data creates a post" do
      valid_attrs = %{content: "some content", subtitle: "some subtitle", title: "some title"}

      assert {:ok, %Post{} = post} = Posts.create_post(valid_attrs)
      assert post.content == "some content"
      assert post.subtitle == "some subtitle"
      assert post.title == "some title"
    end

    test "create_post/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Posts.create_post(@invalid_attrs)
    end

    test "update_post/2 with valid data updates the post" do
      post = post_fixture()

      update_attrs = %{
        content: "some updated content",
        subtitle: "some updated subtitle",
        title: "some updated title"
      }

      assert {:ok, %Post{} = post} = Posts.update_post(post, update_attrs)
      assert post.content == "some updated content"
      assert post.subtitle == "some updated subtitle"
      assert post.title == "some updated title"
    end

    test "update_post/2 with invalid data returns error changeset" do
      post = post_fixture()
      assert {:error, %Ecto.Changeset{}} = Posts.update_post(post, @invalid_attrs)
      assert Repo.preload(post, :comments) == Posts.get_post!(post.id)
    end

    test "delete_post/1 deletes the post" do
      post = post_fixture()
      assert {:ok, %Post{}} = Posts.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Posts.get_post!(post.id) end
    end

    test "delete_post/1 deletes the post and associated comments" do
      post = post_fixture()
      comment = comment_fixture(post_id: post.id)
      assert {:ok, %Post{}} = Posts.delete_post(post)

      assert_raise Ecto.NoResultsError, fn -> Posts.get_post!(post.id) end
      assert_raise Ecto.NoResultsError, fn -> Comments.get_comment!(comment.id) end
    end

    test "change_post/1 returns a post changeset" do
      post = post_fixture()
      assert %Ecto.Changeset{} = Posts.change_post(post)
    end
  end
end
