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
  "hours5" => hours5, "hours6" => hours6, "hours7" => hours7, "hours8" => hours8}) do
    hour = [hours1, hours2, hours3, hours4, hours5, hours6, hours7, hours8]
    hour = Enum.map(hour, fn x -> {if String.length(x) === 0 do
      0
    else
      {a, _} = Integer.parse(x)
      a
    end}end)
    hour = Enum.map(hour, fn {x} -> x end)
    {_, total} = Enum.map_reduce(hour, 0, fn x, acc -> {x, x + acc} end)
    if total === 8 do
      render(conn, "show.html")
    else
      conn
      |> put_flash(:info, "invalid hours")

      |> redirect(to: Routes.task_path(conn, :show, 1))
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

  def show(conn, %{"id" => _id}) do
    render(conn, "show.html")
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
