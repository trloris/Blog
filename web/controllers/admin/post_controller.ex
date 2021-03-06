defmodule Blog.Admin.PostController do
  use Blog.Web, :controller

  alias Blog.Post

  plug :authenticate
  plug :scrub_params, "post" when action in [:create, :update]
  plug :action

  def authenticate(conn, _) do
    if get_session(conn, :user_id) do
      conn
    else
      conn |> redirect to: admin_log_in_path(conn, :login)
    end
  end

  def index(conn, _params) do
    posts =
      from(p in Post, order_by: [desc: :inserted_at])
      |> Repo.all
    render(conn, "index.html", posts: posts)
  end

  def new(conn, _params) do
    changeset = Post.changeset(%Post{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"post" => post_params}) do
    post_params = post_params |> Map.put("formatted_body",
                                         Earmark.to_html(post_params["body"]))
    changeset = Post.changeset(%Post{}, post_params)

    if changeset.valid? do
      Repo.insert(changeset)

      conn
      |> put_flash(:info, "Post created successfully.")
      |> redirect(to: admin_post_path(conn, :index))
    else
      render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    post = Repo.get(Post, id)
    render(conn, "show.html", post: post)
  end

  def edit(conn, %{"id" => id}) do
    post = Repo.get(Post, id)
    changeset = Post.changeset(post)
    render(conn, "edit.html", post: post, changeset: changeset)
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = Repo.get(Post, id)
    post_params = post_params |> Map.put("formatted_body",
                                         Earmark.to_html(post_params["body"]))
    changeset = Post.changeset(post, post_params)

    if changeset.valid? do
      Repo.update(changeset)

      conn
      |> put_flash(:info, "Post updated successfully.")
      |> redirect(to: admin_post_path(conn, :index))
    else
      render(conn, "edit.html", post: post, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    post = Repo.get(Post, id)
    Repo.delete(post)

    conn
    |> put_flash(:info, "Post deleted successfully.")
    |> redirect(to: admin_post_path(conn, :index))
  end
end
