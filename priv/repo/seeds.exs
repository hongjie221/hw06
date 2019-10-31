# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Timesheet.Repo.insert!(%Timesheet.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Timesheet.Repo
alias Timesheet.Workers.Worker
alias Timesheet.Managers.Manager
alias Timesheet.Jobs.Job

pw = Argon2.hash_pwd_salt("password1234")

Repo.insert!(%Manager{id: 1, email: "alice@acme.com", name: "Alice Anderson", password_hash: pw})
Repo.insert!(%Manager{id: 2, email: "bob@acme.com", name: "Bob Anderson", password_hash: pw})
Repo.insert!(%Worker{id: 1, email: "carol@acme.com", name: "Carol Anderson", password_hash: pw, manager_id: 1})
Repo.insert!(%Worker{id: 2, email: "dave@acme.com", name: "Dave Anderson", password_hash: pw, manager_id: 2})


Repo.insert!(%Job{id: 1, jobcode: "VAOR-01",budget: 20, manager_id: 1, description: "2aaeae"})
Repo.insert!(%Job{id: 2, jobcode: "VAOR-02",budget: 45, manager_id: 1, description: "jjjjjjjjj"})
Repo.insert!(%Job{id: 3, jobcode: "VAOR-03",budget: 12, manager_id: 2, description: "jewwwwww"})


