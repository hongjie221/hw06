defmodule Timesheet.Workers do
  @moduledoc """
  The Workers context.
  """

  import Ecto.Query, warn: false
  alias Timesheet.Repo

  alias Timesheet.Workers.Worker

  @doc """
  Returns the list of workers.

  ## Examples

      iex> list_workers()
      [%Worker{}, ...]

  """
  def list_workers do
    Repo.all(Worker)
  end

  @doc """
  Gets a single worker.

  Raises `Ecto.NoResultsError` if the Worker does not exist.

  ## Examples

      iex> get_worker!(123)
      %Worker{}

      iex> get_worker!(456)
      ** (Ecto.NoResultsError)

  """
  def get_worker!(id), do: Repo.get!(Worker, id)

  @doc """
  Creates a worker.

  ## Examples

      iex> create_worker(%{field: value})
      {:ok, %Worker{}}

      iex> create_worker(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_worker(attrs \\ %{}) do
    %Worker{}
    |> Worker.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a worker.

  ## Examples

      iex> update_worker(worker, %{field: new_value})
      {:ok, %Worker{}}

      iex> update_worker(worker, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_worker(%Worker{} = worker, attrs) do
    worker
    |> Worker.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Worker.

  ## Examples

      iex> delete_worker(worker)
      {:ok, %Worker{}}

      iex> delete_worker(worker)
      {:error, %Ecto.Changeset{}}

  """
  def delete_worker(%Worker{} = worker) do
    Repo.delete(worker)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking worker changes.

  ## Examples

      iex> change_worker(worker)
      %Ecto.Changeset{source: %Worker{}}

  """
  def change_worker(%Worker{} = worker) do
    Worker.changeset(worker, %{})
  end

  def get_worker_by_email(email) do
    Repo.get_by(Worker, email: email)
  end

  def get_worker(id), do: Repo.get(Worker, id)

  def get_workers_by_manager_id(manager_id) do
    query = from(w in Worker, where: w.manager_id == ^manager_id, select: {w.id})
    worker_id_list = Repo.all(query)
    Enum.map(worker_id_list, fn {x} -> x end)
  end

  def authenticate(email, pass) do
    worker = Repo.get_by(Worker, email: email)

    case Argon2.check_pass(worker, pass) do
      {:ok, worker} -> worker
      _ -> nil
    end
  end

  def get_manager_id_by_id(worker_id) do
    query = from(w in Worker, where: w.id == ^worker_id, select: {w.manager_id})
    Enum.map(Repo.all(query), fn {x} -> x end)
  end

  def get_worker_name_by_id(worker_id) do
    query = from(w in Worker, where: w.id == ^worker_id, select: {w.name})
    Enum.map(Repo.all(query), fn {x} -> x end)
  end

end
