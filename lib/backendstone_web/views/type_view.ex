defmodule BackendstoneWeb.TypeView do
  use BackendstoneWeb, :view
  alias BackendstoneWeb.TypeView

  def render("index.json", %{types: types}) do
    %{data: render_many(types, TypeView, "type.json")}
  end

  def render("show.json", %{type: type}) do
    %{data: render_one(type, TypeView, "type.json")}
  end

  def render("type.json", %{type: type}) do
    %{id: type.id,
      name: type.name}
  end
end
