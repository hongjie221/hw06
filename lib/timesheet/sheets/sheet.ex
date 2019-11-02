defmodule Timesheet.Sheets.Sheet do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sheets" do
    field :status, :boolean, default: false
    field :worker_id, :id
    field :date, :date
    has_many :tasks, Timesheet.Tasks.Task

    timestamps()
  end

  @doc false
  def changeset(sheet, attrs) do
    sheet
    |> cast(attrs, [:status, :worker_id, :date])
    |> validate_required([:status, :worker_id])
    |> unique_constraint(:worker_id, name: :worker_id_sheet_date_index)
  end
end
