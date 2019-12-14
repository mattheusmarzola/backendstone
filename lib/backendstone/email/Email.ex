defmodule Backendstone.Email.Email do
  import Bamboo.Email

  def withdrawal_email(user, transaction) do
    new_email(
      to: {user.username, user.email},
      from: {"Backend Stone", "backend@stone.com"},
      subject: "Transação realizada na conta n# #{transaction.account.id}",
      html_body: "<strong>Saque realizado com sucesso!</strong> <br/>" <>
                 "Valor do saque: R$ #{transaction.amount}. <br/>" <>
                 "Acesse sua conta para consultar seu saldo final clicando aqui: link_para_conta",
      text_body: "Saque realizado com sucesso! Valor do saque: R$ #{transaction.amount}. "<>
                  "Acesse sua conta para consultar seu saldo final clicando aqui: link_para_conta"
    )
  end
end
