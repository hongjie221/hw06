defmodule Timesheet.Repo.Migrations.CreateSheets do
  use Ecto.Migration

  def change do
    create table(:sheets) do
      add :status, :boolean, default: false, null: false
      add :worker_id, references(:workers, on_delete: :nothing)

      timestamps()
    end

    create index(:sheets, [:worker_id])
  end
end
