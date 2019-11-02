defmodule Timesheet.Sheets do
  @moduledoc """
  The Sheets context.
  """

  import Ecto.Query, warn: false
  alias Timesheet.Repo

  alias Timesheet.Sheets.Sheet

  @doc """
  Returns the list of sheets.

  ## Examples

      iex> list_sheets()
      [%Sheet{}, ...]

  """
  def list_sheets do
    Repo.all(Sheet)
  end

  @doc """
  Gets a single sheet.

  Raises `Ecto.NoResultsError` if the Sheet does not exist.

  ## Examples

      iex> get_sheet!(123)
      %Sheet{}

      iex> get_sheet!(456)
      ** (Ecto.NoResultsError)

  """
  def get_sheet!(id), do: Repo.get!(Sheet, id)

  @doc """
  Creates a sheet.

  ## Examples

      iex> create_sheet(%{field: value})
      {:ok, %Sheet{}}

      iex> create_sheet(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_sheet(attrs \\ %{}) do
    {:ok, sheet} = %Sheet{}
    |> Sheet.changeset(attrs)
    |> Repo.insert(on_conflict: :nothing)
    if is_nil(sheet.id) do
      {:error, "You have a timesheet at the date"}
    else
      {:ok, sheet}
    end
  end

  @doc """
  Updates a sheet.

  ## Examples

      iex> update_sheet(sheet, %{field: new_value})
      {:ok, %Sheet{}}

      iex> update_sheet(sheet, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_sheet(%Sheet{} = sheet, attrs) do
    sheet
    |> Sheet.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Sheet.

  ## Examples

      iex> delete_sheet(sheet)
      {:ok, %Sheet{}}

      iex> delete_sheet(sheet)
      {:error, %Ecto.Changeset{}}

  """
  def delete_sheet(%Sheet{} = sheet) do
    Repo.delete(sheet)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking sheet changes.

  ## Examples

      iex> change_sheet(sheet)
      %Ecto.Changeset{source: %Sheet{}}

  """
  def change_sheet(%Sheet{} = sheet) do
    Sheet.changeset(sheet, %{})
  end

  def get_all_sheet_id_by_worker_id(worker_id) do
    query = from(s in Sheet, where: s.worker_id == ^worker_id, select: {s.id})
    Enum.map(Repo.all(query), fn {x} -> x end)
  end

  def get_sheet_status_by_id(sheet_id) do
    query = from(s in Sheet, where: s.id == ^sheet_id, select: {s.status})
    Enum.map(Repo.all(query), fn {x} -> x end)
  end

  def change_sheet_status_by_id(sheet_id) do
    from(s in Sheet, where: s.id == ^sheet_id)
    |> Repo.update_all(set: [status: true])
  end

  def get_worker_id_by_id(sheet_id) do
    query = from(s in Sheet, where: s.id == ^sheet_id, select: {s.worker_id})
    Enum.map(Repo.all(query), fn {x} -> x end)
  end

  def get_date_by_id(sheet_id) do
    query = from(s in Sheet, where: s.id == ^sheet_id, select: {s.date})
    date = Enum.map(Repo.all(query), fn {x} -> x end)
    Enum.map(date, fn x -> Date.to_string(x) end)
  end


end
