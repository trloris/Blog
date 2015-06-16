defmodule Blog.Router do
  use Blog.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Blog do
    pipe_through :browser # Use the default browser stack

    get "/", PostController, :home

    get "/posts/page/:page", PostController, :index
    get "/posts/:id", PostController, :show
  end

  scope "/admin", Blog.Admin, as: :admin do
    pipe_through :browser
    get "/", LogInController, :login
    post "/", LogInController, :login_post

    resources "/posts", PostController
  end

  # Other scopes may use custom stacks.
  # scope "/api", Blog do
  #   pipe_through :api
  # end
end
