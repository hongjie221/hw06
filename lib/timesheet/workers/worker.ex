defmodule Timesheet.Workers.Worker do
  use Ecto.Schema
  import Ecto.Changeset

  schema "workers" do
    field :email, :string, null: false
    field :name, :string, null: false
    field :password_hash, :string
    field :password, :string, virtual: true
    belongs_to :manager, Timesheet.Managers.Manager
    has_many :tasks, Timesheet.Tasks.Task
    timestamps()
  end

  @doc false
  def changeset(worker, attrs) do
    worker
    |> cast(attrs, [:email, :name, :password])
    |> validate_length(:password, min: 12)
    |> hash_password()
    |> validate_required([:email, :name, :password_hash])
  end

  def hash_password(cset) do
    pw = get_change(cset, :password)
    if pw do
      change(cset, Argon2.add_hash(pw))
    else
      cset
    end
  end
end
