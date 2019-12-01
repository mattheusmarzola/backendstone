defmodule BackendstonWeb.PageController do
  use BackendstonWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
