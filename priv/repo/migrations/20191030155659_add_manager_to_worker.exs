defmodule Timesheet.Repo.Migrations.AddManagerToWorker do
  use Ecto.Migration

  def change do
    alter table("workers") do
      add :manager_id, references(:managers, on_delete: :nothing)
    end

  end
end
