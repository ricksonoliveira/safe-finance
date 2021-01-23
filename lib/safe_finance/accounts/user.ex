defmodule SafeFinance.Accounts.User do
  @moduledoc """
    User Schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id,  :binary_id, autogenerate: true}
  @derive {Phoenix.Param, key: :id}
  schema "users" do
    field :email, :string
    field :name, :string
    field :password, :string, virtual: true
    field :password_hash, :string

    has_one :user_finances, SafeFinance.Accounts.UserFinances

    timestamps()
  end

  @spec changeset(
          {map, map} | %{:__struct__ => atom | %{__changeset__: map}, optional(atom) => any},
          :invalid | %{optional(:__struct__) => none, optional(atom | binary) => any}
        ) :: Ecto.Changeset.t()
  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :password])
    |> validate_required([:name, :email, :password])
    |> validate_format(:email, ~r/@/, message: "Invalid email format")
    |> validate_length(
      :password,
      min: 6,
      max: 100,
      message: "Password min is 6 characters and max 100 characters"
    )
    |> unique_constraint(:email, message: "This email already exists in our database!")
    |> hash_password()
  end

  defp hash_password(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, Argon2.add_hash(password))
  end

  defp hash_password(changeset) do
    changeset
  end
end
