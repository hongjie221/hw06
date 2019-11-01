defmodule TimesheetWeb.TaskController do
  use TimesheetWeb, :controller
  alias Timesheet.Tasks
  alias Timesheet.Tasks.Task

  def index(conn, %{"allJobs" => allJobs}) do
    render(conn, "index.html", allJobs: allJobs)
  end

  def new(conn, _params) do
    changeset = Tasks.change_task(%Task{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"hours1" => hours1, "hours2" => hours2, "hours3" => hours3, "hours4" => hours4,
  "hours5" => hours5, "hours6" => hours6, "hours7" => hours7, "hours8" => hours8, "job_code1" => jobcode1,
  "job_code2" => jobcode2, "job_code3" => jobcode3, "job_code4" => jobcode4, "job_code5" => jobcode5,
  "job_code6" => jobcode6, "job_code7" => jobcode7, "job_code8" => jobcode8, "note1" => note1, "note2" => note2,
  "note3" => note3, "note4" => note4, "note5" => note5, "note6" => note6, "note7" => note7, "note8" => note8}) do
    hour = [hours1, hours2, hours3, hours4, hours5, hours6, hours7, hours8]
    jobcode = [jobcode1, jobcode2, jobcode3, jobcode4, jobcode5, jobcode6, jobcode7, jobcode8]
    note = [note1, note2, note3, note4, note4, note6, note7, note8]
    hour = Enum.map(hour, fn x -> {if String.length(x) === 0 do
      0
    else
      {a, _} = Integer.parse(x)
      a
    end}end)
    hour = Enum.map(hour, fn {x} -> x end)
    combo = Enum.zip(hour, jobcode)
    combo_with_note = Enum.zip(combo, note)
    {_, total} = Enum.map_reduce(hour, 0, fn x, acc -> {x, x + acc} end)
    if total === 8 do
      current_worker_id = get_session(conn, :worker_id)
      {:ok, sheet} = Timesheet.Sheets.create_sheet(%{worker_id: current_worker_id, status: false})

      Enum.map(combo_with_note, fn {{x, y}, z} -> {
        Timesheet.Tasks.create_task(%{hours: x, job_id: Timesheet.Jobs.get_job_id_by_code(y),
        worker_id: current_worker_id, sheet_id: sheet.id, note: z})}
      end
      )
      sheets = Timesheet.Sheets.get_all_sheet_id_by_worker_id(current_worker_id)
      all_tasks = Enum.map(sheets, fn x -> Timesheet.Tasks.get_task_by_sheet_id(x) end)
      all_status = Enum.map(sheets, fn x -> Timesheet.Sheets.get_sheet_status_by_id(x) end)
      all_combo = Enum.zip(all_tasks, all_status)
      render(conn, "show.html", all_combo: all_combo)
    else
      all_combo = 1
      conn
      |> put_flash(:info, "invalid hours")
      |> redirect(to: Routes.task_path(conn, :show, all_combo))
      #render(conn, "show.html")
    end
    #case Tasks.create_task(task_params) do
      #{:ok, task} ->
        #conn
        #|> put_flash(:info, "Task created successfully.")
        #|> redirect(to: Routes.task_path(conn, :show, task))

      #{:error, %Ecto.Changeset{} = changeset} ->
        #render(conn, "new.html", changeset: changeset)
    #end
  end

  def show(conn, %{"id" => all_combo}) do
    render(conn, "show.html", all_combo: all_combo)
  end

  def edit(conn, %{"id" => id}) do
    task = Tasks.get_task!(id)
    changeset = Tasks.change_task(task)
    render(conn, "edit.html", task: task, changeset: changeset)
  end

  def update(conn, %{"id" => id, "task" => task_params}) do
    task = Tasks.get_task!(id)

    case Tasks.update_task(task, task_params) do
      {:ok, task} ->
        conn
        |> put_flash(:info, "Task updated successfully.")
        |> redirect(to: Routes.task_path(conn, :show, task))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", task: task, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    task = Tasks.get_task!(id)
    {:ok, _task} = Tasks.delete_task(task)

    conn
    |> put_flash(:info, "Task deleted successfully.")
    |> redirect(to: Routes.task_path(conn, :index))
  end
end
