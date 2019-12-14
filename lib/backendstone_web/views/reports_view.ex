defmodule BackendstoneWeb.ReportsView do
  use BackendstoneWeb, :view

  def render("total.json", %{report: report}) do
    %{total: report["total"],
      year: report["year"],
      month: report["month"],
      day: report["day"],
      type_id: report["type_id"],
      status_id: report["transaction_status_id"]}
  end

end
