defmodule Timesheet.Repo.Migrations.CreateJobs do
  use Ecto.Migration

  def change do
    create table(:jobs) do
      add :jobcode, :string
      add :budget, :integer

      timestamps()
    end


  end
end
