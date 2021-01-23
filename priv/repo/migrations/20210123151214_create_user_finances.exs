defmodule SafeFinance.Repo.Migrations.CreateUserFinances do
  @moduledoc """
    Migration para criar tabela user_finances
  """
  use Ecto.Migration

  def change do
    create table(:user_finances, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :balance, :decimal, precision: 10, scale: 2
      add :currency, :string
      add :user_id, references(:users, on_delete: :delete_all, type: :uuid)

      timestamps()
    end

  end
end
