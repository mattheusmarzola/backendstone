defmodule BackendstoneWeb.SessionView do
  use BackendstoneWeb, :view

  def render("jwt.json", %{jwt: jwt}) do
    %{jwt: jwt}
  end
end
