defmodule Timesheet.Repo.Migrations.AddNotesToTasks do
  use Ecto.Migration

  def change do
    alter table("tasks") do
      add :note, :string, default: "", null: false
    end

  end
end
