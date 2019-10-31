defmodule Timesheet.Repo.Migrations.AddReferencesTasksAndSheet do
  use Ecto.Migration

  def change do
    alter table("tasks") do
      add :sheet_id, references(:sheets, on_delete: :delete_all), null: false
    end
  end
end
