defmodule BackendstoneWeb.UserView do
  use BackendstoneWeb, :view
  alias BackendstoneWeb.UserView

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      email: user.email,
      username: user.username
    }
  end

  def render("jwt.json", %{jwt: jwt}) do
    %{jwt: jwt}
  end

end
