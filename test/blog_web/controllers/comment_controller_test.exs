defmodule BlogWeb.CommentControllerTest do
  use BlogWeb.ConnCase

  import Blog.CommentsFixtures
  import Blog.PostsFixtures

  describe "create comment" do
    test "redirects to show when data is valid", %{conn: conn} do
      post = post_fixture()
      create_attrs = %{content: "some content", post_id: post.id}
      conn = post(conn, ~p"/comments", comment: create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/posts/#{post.id}"

      conn = get(conn, ~p"/posts/#{post.id}")
      assert html_response(conn, 200) =~ "some content"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      post = post_fixture()
      invalid_attrs = %{content: nil, post_id: post.id}
      conn = post(conn, ~p"/comments", comment: invalid_attrs)
      assert html_response(conn, 200) =~ "can&#39;t be blank"
    end
  end

  describe "update comment" do
    test "redirects when data is valid", %{conn: conn} do
      post = post_fixture()
      comment = comment_fixture(post_id: post.id)
      update_attrs = %{content: "some updated content", post_id: post.id}
      conn = put(conn, ~p"/comments/#{comment}", comment: update_attrs)
      assert redirected_to(conn) == ~p"/posts/#{post.id}"

      conn = get(conn, ~p"/posts/#{post.id}")
      assert html_response(conn, 200) =~ update_attrs.content
    end
  end

  describe "delete comment" do
    test "deletes chosen comment", %{conn: conn} do
      post = post_fixture()
      comment = comment_fixture(content: "some comment content", post_id: post.id)
      conn = delete(conn, ~p"/comments/#{comment}")
      assert redirected_to(conn) == ~p"/posts/#{post.id}"

      conn = get(conn, ~p"/posts/#{post.id}")
      refute html_response(conn, 200) =~ "some comment content"
    end
  end
end
