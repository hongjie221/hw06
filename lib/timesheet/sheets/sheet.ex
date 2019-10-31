defmodule Timesheet.Sheets.Sheet do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sheets" do
    field :status, :boolean, default: false
    field :worker_id, :id
    has_many :tasks, Timesheet.Tasks.Task

    timestamps()
  end

  @doc false
  def changeset(sheet, attrs) do
    sheet
    |> cast(attrs, [:status, :worker_id])
    |> validate_required([:status, :worker_id])
  end
end
