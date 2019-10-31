defmodule Timesheet.Jobs.Job do
  use Ecto.Schema
  import Ecto.Changeset

  schema "jobs" do
    field :budget, :integer, null: false
    field :jobcode, :string, null: false
    field :description, :string, null: false
    belongs_to :manager, Timesheet.Managers.Manager

    timestamps()
  end

  @doc false
  def changeset(job, attrs) do
    job
    |> cast(attrs, [:jobcode, :budget])
    |> validate_required([:jobcode, :budget])
  end
end
