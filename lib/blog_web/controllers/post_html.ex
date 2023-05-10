defmodule BlogWeb.PostHTML do
  use BlogWeb, :html
  alias Blog.Comments
  alias Blog.Comments.Comment

  embed_templates "post_html/*"

  @doc """
  Renders a post form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def post_form(assigns)
end
