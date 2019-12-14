defmodule BackendstoneWeb.ErrorView do
  use BackendstoneWeb, :view

  def render("400.json", changeset) do
    %{errors: Ecto.Changeset.traverse_errors(changeset, &translate_error/1)}
  end

  def render("409.json", changeset) do
    %{errors: Ecto.Changeset.traverse_errors(changeset, &translate_error/1)}
  end

  def render("404.json", _assings) do
    %{errors: %{message: "Resource not found"}}
  end

  def render("401.json", %{message: message}) do
    %{errors: %{detail: message}}
  end

  def render("500.json", %{message: message}) do
    %{errors: %{detail: message}}
  end
end
