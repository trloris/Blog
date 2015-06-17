defmodule Blog.PostController do
  use Blog.Web, :controller

  alias Blog.Post

  plug :action

  def home(conn, _param) do
    query = from p in Post, limit: 10, offset: 0
    posts = Repo.all query

    count =
      (from p in Post, select: count(p.id))
      |> Repo.one

    next = next_page(count, 1)
    render(conn, "index.html", posts: posts, page: 1, previous: nil, next: next)
  end

  def index(conn, %{"page" => page}) do
    page = String.to_integer(page)
    offset = (page - 1) * 10
    query = from p in Post, limit: 10, offset: ^offset
    posts = Repo.all query

    count =
      (from p in Post, select: count(p.id))
      |> Repo.one

    previous = previous_page(page)
    next = next_page(count, page)
    render(conn, "index.html", posts: posts, page: page, previous: previous, next: next)
  end

  def show(conn, %{"id" => id}) do
    post = Repo.get(Post, id)
    render(conn, "show.html", post: post)
  end

  defp previous_page(page) do
    if page > 1 do
      page - 1
    else
      nil
    end
  end

  defp next_page(count, page) do
    if count > page * 10 do
      page + 1
    else
      nil
    end
  end
end
