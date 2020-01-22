defmodule Crit.Repo.Migrations.ExampleTables do
  use Ecto.Migration

  def change do
    create table(:animals) do
      add :name, :string
      timestamps()
    end

    create table(:service_gaps) do
      add :starts_at, :utc_datetime
      add :ends_at, :utc_datetime
      add :reason, :string
      add :animal_id, references(:animals, on_delete: :delete_all)
      timestamps()
    end
  end
end
