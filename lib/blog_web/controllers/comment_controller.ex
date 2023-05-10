defmodule BlogWeb.CommentController do
  use BlogWeb, :controller
  plug(:put_view, BlogWeb.PostHTML)

  alias Blog.Comments
  alias Blog.Comments.Comment
  alias Blog.Posts

  def create(conn, %{"comment" => comment_params}) do
    case Comments.create_comment(comment_params) do
      {:ok, comment} ->
        conn
        |> put_flash(:info, "Comment created successfully.")
        |> redirect(to: ~p"/posts/#{comment.post_id}")

      {:error, %Ecto.Changeset{} = comment_changeset} ->
        post = Posts.get_post!(comment_params["post_id"])
        render(conn, :show, post: post, comment_changeset: comment_changeset)
    end
  end

  def update(conn, %{"id" => id, "comment" => comment_params}) do
    comment = Comments.get_comment!(id)

    case Comments.update_comment(comment, comment_params) do
      {:ok, comment} ->
        conn
        |> put_flash(:info, "Comment updated successfully.")
        |> redirect(to: ~p"/posts/#{comment.post_id}")

      {:error, %Ecto.Changeset{} = comment_changeset} ->
        post = Posts.get_post!(comment.post_id)

        render(conn, :show, post: post, comment_changeset: Comments.change_comment(%Comment{}))
    end
  end

  def delete(conn, %{"id" => id}) do
    comment = Comments.get_comment!(id)
    {:ok, _comment} = Comments.delete_comment(comment)

    conn
    |> put_flash(:info, "Comment deleted successfully.")
    |> redirect(to: ~p"/posts/#{comment.post_id}")
  end
end
