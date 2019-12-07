defmodule Backendstone.UserManager.Guardian do
  use Guardian, otp_app: :backendstone

  alias Backendstone.UserManager

  def subject_for_token(user, _claims) do
    sub = to_string(user.id)
    {:ok, sub}
  end

  def subject_for_token(_, _) do
    {:error, :resource_not_found}
  end

  def resource_from_claims(claims) do
    id = claims["sub"]
    resource = UserManager.get_user!(id)
    {:ok,  resource}
  end

  def resource_from_claims(_claims) do
    {:error, :resource_not_found}
  end
end
