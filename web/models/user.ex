defmodule Blog.User do
  use Blog.Web, :model
  import Comeonin.Bcrypt

  schema "users" do
    field :name, :string
    field :password, :string

    timestamps
  end

  @required_fields ~w(name password)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If `params` are nil, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def authenticate?(name, password) do
    query = from u in Blog.User,
            where: u.name == ^name

    user = Blog.Repo.one query

    if user && checkpw(password, user.password) do
      user
    else
      nil
    end
  end
end
