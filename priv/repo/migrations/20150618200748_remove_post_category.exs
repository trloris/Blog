defmodule Blog.Repo.Migrations.RemovePostCategory do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      remove :category
    end
  end
end
