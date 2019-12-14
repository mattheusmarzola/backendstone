defmodule BackendstoneWeb.ReportsController do
  use BackendstoneWeb, :controller

  alias Backendstone.Reports

  action_fallback BackendstoneWeb.FallbackController

  def total_transactions(conn, params) do
    with {:ok, total} <- {:ok, Reports.total_transaction(params)} do
      params =
        params
        |> Map.put("total", total)

      conn
      |> put_status(:ok)
      |> render("total.json", report: params)
    end
  end

end
