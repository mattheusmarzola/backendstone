defmodule Backendstone.UserManager.AuthPipeline do
  use Guardian.Plug.Pipeline, otp_app: :backendstone,
    error_handler: Backendstone.UserManager.ErrorHandler,
    module: Backendstone.UserManager.Guardian


    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.EnsureAuthenticated
    plug Guardian.Plug.LoadResource
  end
