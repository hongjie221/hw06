defmodule Timesheet.Repo.Migrations.AddDateToTimesheet do
  use Ecto.Migration

  def change do
    alter table("sheets") do
      add :date, :date, null: false
    end

  end
end
