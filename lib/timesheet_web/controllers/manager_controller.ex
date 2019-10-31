defmodule TimesheetWeb.ManagerController do
  use TimesheetWeb, :controller

  alias Timesheet.Managers
  alias Timesheet.Managers.Manager

  def index(conn, _params) do
    managers = Managers.list_managers()
    render(conn, "index.html", managers: managers)
  end

  def new(conn, _params) do
    changeset = Managers.change_manager(%Manager{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"manager" => manager_params}) do
    case Managers.create_manager(manager_params) do
      {:ok, manager} ->
        conn
        |> put_flash(:info, "Manager created successfully.")
        |> redirect(to: Routes.manager_path(conn, :show, manager))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    manager = Managers.get_manager!(id)
    render(conn, "show.html", manager: manager)
  end

  def edit(conn, %{"id" => id}) do
    manager = Managers.get_manager!(id)
    changeset = Managers.change_manager(manager)
    render(conn, "edit.html", manager: manager, changeset: changeset)
  end

  def update(conn, %{"id" => id, "manager" => manager_params}) do
    manager = Managers.get_manager!(id)

    case Managers.update_manager(manager, manager_params) do
      {:ok, manager} ->
        conn
        |> put_flash(:info, "Manager updated successfully.")
        |> redirect(to: Routes.manager_path(conn, :show, manager))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", manager: manager, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    manager = Managers.get_manager!(id)
    {:ok, _manager} = Managers.delete_manager(manager)

    conn
    |> put_flash(:info, "Manager deleted successfully.")
    |> redirect(to: Routes.manager_path(conn, :index))
  end
end
