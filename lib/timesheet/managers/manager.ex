defmodule Timesheet.Managers.Manager do
  use Ecto.Schema
  import Ecto.Changeset

  schema "managers" do
    field :email, :string, null: false
    field :name, :string, null: false
    has_many :workers, Timesheet.Workers.Worker
    has_many :jobs, Timesheet.Jobs.Job

    timestamps()
  end

  @doc false
  def changeset(manager, attrs) do
    manager
    |> cast(attrs, [:id, :name, :email])
    |> validate_required([:id, :name, :email])
  end
end
