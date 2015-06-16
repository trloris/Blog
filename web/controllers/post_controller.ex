defmodule Blog.PostController do
  use Blog.Web, :controller

  alias Blog.Post

  plug :action

  def home(conn, _param) do
    query = from p in Post, limit: 10, offset: 0
    posts = Repo.all query
    render(conn, "index.html", posts: posts)
  end

  def index(conn, %{"page" => page}) do
    page = String.to_integer(page)
    offset = (page - 1) * 10
    query = from p in Post, limit: 10, offset: ^offset
    posts = Repo.all query
    render(conn, "index.html", posts: posts)
  end

  def show(conn, %{"id" => id}) do
    post = Repo.get(Post, id)
    render(conn, "show.html", post: post)
  end
end
