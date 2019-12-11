defmodule Backendstone.Email do
  import Bamboo.Email

  def welcome_email(user, account, transaction) do
    new_email(
      to: user.email,
      from: "backend@stone.com",
      subject: "Transação realizada na conta n# #{account.id}",
      html_body: "<strong>Transação realizada na conta!</strong> <br/>",
      text_body: "Thanks for joining!"
    )
  end
end
