defmodule Server.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :body, :string
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:comments, [:user_id])
  end
end
