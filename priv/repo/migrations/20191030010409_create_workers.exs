defmodule Timesheet.Repo.Migrations.CreateWorkers do
  use Ecto.Migration

  def change do
    create table(:workers) do
      add :name, :string
      add :email, :string

      timestamps()
    end

  end
end
