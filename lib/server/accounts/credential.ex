defmodule Server.Accounts.Credential do
  use Ecto.Schema
  import Ecto.Changeset
  alias Server.Accounts.{Credential, User}


  schema "credentials" do
    field :password, :string, virtual: true
    field :password_hash, :string
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(%Credential{} = credential, attrs) do
    credential
    |> cast(attrs, [:password])
    |> validate_required([:password])
    |> validate_length(:password, min: 6, max: 100)
    |> put_password_hash
  end

  @doc """
  Creates and stores password hash
  """
  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(password))
      _ ->
        changeset
    end
  end

end
