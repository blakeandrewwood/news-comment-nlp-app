defmodule Server.Content.Comment do
  use Ecto.Schema
  import Ecto.Changeset
  alias Server.Content.{Comment, User}


  schema "comments" do
    field :body, :string
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(%Comment{} = comment, attrs) do
    comment
    |> cast(attrs, [:body])
    |> validate_required([:body])
  end
end
