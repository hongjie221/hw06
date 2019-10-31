defmodule Timesheet.Repo.Migrations.RemoveDateFromSheets do
  use Ecto.Migration

  def change do
    alter table(:sheets) do
      remove :date
    end
  end
end
