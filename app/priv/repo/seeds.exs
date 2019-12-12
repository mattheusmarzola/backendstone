# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Backendstone.Repo.insert!(%Backendstone.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

[ %{name: "Withdrawal"},
  %{name: "Deposit"},
  %{name: "Transference"}]
|> Enum.map(&Backendstone.Transactions.create_type/1)

[ %{name: "Pending"},
  %{name: "Denied"},
  %{name: "Executed"}]
|> Enum.map(&Backendstone.Transactions.create_transaction_status/1)


