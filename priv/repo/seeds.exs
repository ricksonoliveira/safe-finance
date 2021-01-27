# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     SafeFinance.Repo.insert!(%SafeFinance.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

SafeFinance.Accounts.create_user(%{
  name: "Rick G.",
  email: "rikson@gmail.com",
  password: "123456"
})
