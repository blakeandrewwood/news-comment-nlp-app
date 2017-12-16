defmodule Server.Accounts.Credential do
  use Ecto.Schema
  import Ecto.Changeset
  alias Server.Accounts.{Credential, User}


  schema "credentials" do
    field :password, :string
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(%Credential{} = credential, attrs) do
    credential
    |> cast(attrs, [:password])
    |> validate_required([:password])
  end
end
