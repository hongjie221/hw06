defmodule Timesheet.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :hours, :integer
    field :job_id, :id
    field :worker_id, :id
    belongs_to :sheet, Timesheet.Sheets.Sheet

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:hours, :job_id, :worker_id, :sheet_id])
    |> validate_required([:hours, :sheet_id])
  end
end
