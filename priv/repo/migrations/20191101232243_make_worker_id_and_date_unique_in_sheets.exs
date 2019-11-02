defmodule Timesheet.Repo.Migrations.MakeWorkerIdAndDateUniqueInSheets do
  use Ecto.Migration

  def change do
    create unique_index(:sheets, [:worker_id, :date])

  end
end
