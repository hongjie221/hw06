defmodule Timesheet.Repo.Migrations.ChangeJobcodeUnique do
  use Ecto.Migration

  def change do
    alter table("jobs") do
      modify :jobcode, :string, unique: true
    end

  end
end
