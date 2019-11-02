defmodule TimesheetWeb.SessionController do
  use TimesheetWeb, :controller

  def new(conn, %{"worker" => worker}) do
    render(conn, "new.html")
  end

  def new(conn, %{"manager" => manager}) do

    render(conn, "manager.html")
  end

  def create(conn, %{"worker_email" => worker_email, "password" => password}) do
    worker = Timesheet.Workers.authenticate(worker_email, password)
    allJobs = Timesheet.Jobs.list_job_codes()

    if worker do
      conn
      |> put_session(:worker_email, worker_email)
      |> put_session(:worker_id, worker.id)
      |> put_session(:type, "worker")
      |> put_flash(:info, "Welcome back #{worker_email}")
      |> redirect(to: Routes.task_path(conn, :index, allJobs: allJobs))
     #render(conn, "index.html", allJobs: allJobs)
    else
      conn
      |> put_flash(:error, "Login failed")
      |> redirect(to: Routes.page_path(conn, :index))
    end
  end

  def create(conn, %{"manager_email" => manager_email, "password" => password}) do
    manager = Timesheet.Managers.authenticate(manager_email, password)
    if manager do
      manager_id = manager.id
      conn
      |> put_session(:manager_email, manager_email)
      |> put_session(:manager_id, manager_id)
      |> put_flash(:info, "Welcome back Manager #{manager_email}")
      |> redirect(to: Routes.sheet_path(conn, :edit, manager_id))
    else
      conn
      |> put_flash(:error, "Login failed")
      |> redirect(to: Routes.page_path(conn, :index))
    end
  end


  def delete(conn, %{"worker" => _worker}) do
    conn
    |> delete_session(:worker_id)
    |> put_flash(:info, "Log out")
    |> redirect(to: Routes.page_path(conn, :index))
  end

  def delete(conn, %{"manager" => _manager}) do
    conn
    |> delete_session(:manager_id)
    |> put_flash(:info, "Log out")
    |> redirect(to: Routes.page_path(conn, :index))
  end

end
