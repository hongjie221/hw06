defmodule TimesheetWeb.SheetController do
  use TimesheetWeb, :controller

  alias Timesheet.Sheets
  alias Timesheet.Sheets.Sheet

  def index(conn, _params) do
    sheets = Sheets.list_sheets()
    render(conn, "index.html", sheets: sheets)
  end

  @spec new(any, any) :: none
  def new(conn, _params) do
    changeset = Sheets.change_sheet(%Sheet{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"sheet" => sheet_params}) do
    case Sheets.create_sheet(sheet_params) do
      {:ok, sheet} ->
        conn
        |> put_flash(:info, "Sheet created successfully.")
        |> redirect(to: Routes.sheet_path(conn, :show, sheet))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    Timesheet.Sheets.change_sheet_status_by_id(id)
    all_task = Timesheet.Tasks.get_task_by_sheet_id(id)
    Enum.map(all_task, fn {x, y, _} -> {
      Timesheet.Jobs.substract_budget_by_job_code(x, y)
    }
    end
    )
    [worker_id] = Timesheet.Sheets.get_worker_id_by_id(id)
    [manager_id] = Timesheet.Workers.get_manager_id_by_id(worker_id)
    worker_list = Timesheet.Workers.get_workers_by_manager_id(manager_id)
    sheet_list = Enum.map(worker_list, fn x -> Timesheet.Sheets.get_all_sheet_id_by_worker_id(x) end)
    sheets_list = Enum.at(sheet_list, 0)
    sheets_status = Enum.map(sheets_list, fn x -> Timesheet.Sheets.get_sheet_status_by_id(x) end)
    render(conn, "show.html", sheets_list: sheets_list, sheets_status: sheets_status)
  end

  def edit(conn, %{"id" => id}) do
    worker_list = Timesheet.Workers.get_workers_by_manager_id(id)
    sheet_list = Enum.map(worker_list, fn x -> Timesheet.Sheets.get_all_sheet_id_by_worker_id(x) end)
    sheets_list = Enum.at(sheet_list, 0)
    sheets_status = Enum.map(sheets_list, fn x -> Timesheet.Sheets.get_sheet_status_by_id(x) end)
    render(conn, "edit.html", sheets_list: sheets_list, sheets_status: sheets_status)
  end

end
