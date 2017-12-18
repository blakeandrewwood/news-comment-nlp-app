defmodule Server.Content do
  @moduledoc """
  The Content context.
  """

  import Ecto.Query, warn: false
  alias Server.Repo

  alias Server.Content.Comment

  @doc """
  Returns the list of comments.

  ## Examples

      iex> list_comments()
      [%Comment{}, ...]

  """
  def list_comments do
    Repo.all(Comment)
    |> Repo.preload(:user)
  end

  @doc """
  Returns the list of comments.

  ## Examples

      iex> list_comments()
      [%Comment{}, ...]

  """
  def list_top_level_comments do
    query =
      from c in Comment,
        where: is_nil(c.comment_id)

    Repo.all(query)
    |> Enum.map(fn(c) -> deep_load_assc_comment(c) end)
  end

  @doc """
  Gets a single comment.

  Raises `Ecto.NoResultsError` if the Comment does not exist.

  ## Examples

      iex> get_comment!(123)
      %Comment{}

      iex> get_comment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_comment!(id) do
    Comment
    |> Repo.get!(id)
    |> Repo.preload(:user)
  end

  @doc """
  Creates a comment.

  ## Examples

      iex> create_comment(%{field: value})
      {:ok, %Comment{}}

      iex> create_comment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_comment(attrs \\ %{}) do
    %Comment{}
    |> Comment.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a comment.

  ## Examples

      iex> update_comment(comment, %{field: new_value})
      {:ok, %Comment{}}

      iex> update_comment(comment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_comment(%Comment{} = comment, attrs) do
    comment
    |> Comment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Comment.

  ## Examples

      iex> delete_comment(comment)
      {:ok, %Comment{}}

      iex> delete_comment(comment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_comment(%Comment{} = comment) do
    Repo.delete(comment)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking comment changes.

  ## Examples

      iex> change_comment(comment)
      %Ecto.Changeset{source: %Comment{}}

  """
  def change_comment(%Comment{} = comment) do
    Comment.changeset(comment, %{})
  end

  def deep_load_assc_comment(comment) do
    new_comment = comment
    |> Repo.preload([:comments, :user])

    new_comments = new_comment.comments
    |> Enum.map(fn(c) -> deep_load_assc_comment(c) end)

    Map.put(new_comment, :comments, new_comments)
  end

  def count_comments(comments) do
    count_comments(comments, length(comments))
  end

  def count_comments(comments, count) do
    count + Enum.reduce(comments, 0, fn(c, acc) -> count_comments(c.comments) + acc end)
  end

end
