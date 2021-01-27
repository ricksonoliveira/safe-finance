defmodule SafeFinance.Accounts.UserFinance do
  @moduledoc """
    UserFinances Schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @derive {Phoenix.Param, key: :id}
  @foreign_key_type Ecto.UUID
  schema "user_finances" do
    field :balance, :decimal, precision: 10, scale: 2, default: 1000
    field :currency, :string, default: "BRL"
    belongs_to :user, SafeFinance.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(user_finance, attrs \\ %{}) do
    user_finance
    |> cast(attrs, [:balance, :currency])
    |> validate_required([:balance, :currency])
  end
end
