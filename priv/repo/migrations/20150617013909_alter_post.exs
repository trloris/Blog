defmodule Blog.Repo.Migrations.AlterPost do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add :formatted_body, :string
    end
  end
end
