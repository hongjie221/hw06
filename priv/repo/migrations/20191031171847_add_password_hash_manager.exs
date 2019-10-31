defmodule Timesheet.Repo.Migrations.AddPasswordHashManager do
  use Ecto.Migration

  def change do
    alter table("managers") do
      add :password_hash, :string, defalut: "", null: false
    end

  end
end
