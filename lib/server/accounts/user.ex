defmodule Server.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Server.Accounts.{User, Credential}


  schema "users" do
    field :username, :string
    has_one :credential, Credential
    has_many :comments, Server.Content.Comment

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:username])
    |> validate_required([:username])
    |> unique_constraint(:username)
  end
end
