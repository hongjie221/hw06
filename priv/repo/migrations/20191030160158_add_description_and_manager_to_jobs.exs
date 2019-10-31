defmodule Timesheet.Repo.Migrations.AddDescriptionAndManagerToJobs do
  use Ecto.Migration

  def change do
    alter table("jobs") do
      add :description, :text, default: "", null: false
      add :manager_id, references(:managers, on_delete: :nothing)
    end

  end
end
