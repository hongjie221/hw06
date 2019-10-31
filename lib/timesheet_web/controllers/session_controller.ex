defmodule TimesheetWeb.SessionController do
  use TimesheetWeb, :controller

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"worker_email" => worker_email, "password" => password}) do
    worker = Timesheet.Workers.authenticate(worker_email, password)
    allJobs = Timesheet.Jobs.list_job_codes()

    if worker do
      conn
      |> put_session(:worker_email, worker_email)
      |> put_session(:worker_id, worker.id)
      |> put_flash(:info, "Welcome back #{worker_email}")
      |> redirect(to: Routes.task_path(conn, :index, allJobs: allJobs))
     #render(conn, "index.html", allJobs: allJobs)
    else
      conn
      |> put_flash(:error, "Login failed")
      |> redirect(to: Routes.page_path(conn, :index))
    end
  end

  def create(conn, %{"manager_email" => manager_email}) do
    manager = Timesheet.Managers.get_manager_by_email(manager_email)
    if manager do
      conn
      |> put_session(:manager_email, manager_email)
      |> put_flash(:info, "Welcome back #{manager_email}")
      |> redirect(to: Routes.page_path(conn, :index))
    else
      conn
      |> put_flash(:error, "Login failed")
      |> redirect(to: Routes.page_path(conn, :index))
    end
  end


  def delete(conn, _params) do
    conn
    |> delete_session(:worker_id)
    |> put_flash(:info, "Log out")
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
