defmodule Blog.Post do
  use Blog.Web, :model

  schema "posts" do
    field :title, :string
    field :body, :string
    field :formatted_body, :string

    timestamps
  end

  @required_fields ~w(title body)
  @optional_fields ~w(formatted_body)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If `params` are nil, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
