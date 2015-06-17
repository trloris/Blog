defmodule Blog.Admin.LogInController do
  use Blog.Web, :controller

  plug :action

  def login(conn, _params) do
    if get_session(conn, :user_id) do
      redirect conn, to: admin_post_path(conn, :index)
    end
    render conn
  end

  def login_post(conn, %{"session" => session}) do
    if user = Blog.User.authenticate?(session["username"], session["password"]) do
      conn
      |> put_session(:user_id, user.id)
      |> redirect to: admin_post_path(conn, :index)
    end
    redirect conn, to: admin_log_in_path(conn, :login)
  end
end
