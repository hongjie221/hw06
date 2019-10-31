defmodule Timesheet.Repo.Migrations.CreateManagers do
  use Ecto.Migration

  def change do
    create table(:managers) do
      add :name, :string
      add :email, :string
      add :worker_id, references(:workers, on_delete: :nothing)
      add :job_id, references(:jobs, on_delete: :nothing)

      timestamps()
    end

    create index(:managers, [:worker_id])
    create index(:managers, [:job_id])
  end
end
