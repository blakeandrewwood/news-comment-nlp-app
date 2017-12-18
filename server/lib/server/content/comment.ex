defmodule Server.Content.Comment do
  use Ecto.Schema
  import Ecto.Changeset
  alias Server.Content.Comment


  schema "comments" do
    field :body, :string
    has_many :comments, Comment
    belongs_to :comment, Comment
    belongs_to :user, Server.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(%Comment{} = comment, attrs) do
    comment
    |> cast(attrs, [:body, :user_id, :comment_id])
    |> validate_required([:body, :user_id])
  end

end
