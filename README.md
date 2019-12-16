# Desafio Backend Stone


Projeto configurado para utilizar no ambiente de desenvolimento o docker-compose, com uma imagem do Elixir:latest, e a instalação do Phoenix 1.4.11, e uma imagem do Postgres.

Para iniciar o projeto localmente `docker-compose up`, o projeto sera iniciado na porta 4000 e o postgres na porta 15432

Para se conectar ao Postgres:

User: postgres

Pass: postgres

Host: localhost:15432

O deploy foi realizado utilizando o Gigalexir (https://gigalixir.com/) e para CD foi utilizado o GitHub Actions

Link para a documentação da API: https://documenter.getpostman.com/view/5027528/SWEB1azi?version=latest

Link para a API publicada: https://lightslategray-stylish-catbird.gigalixirapp.com/

A documentação gerada se encontra em doc/index.html

Obs.:
Ficaram dois itens pendentes:

Finalização da implementação do GenServer para processar as transacoes em fila, utilizando uma fila por conta, para garantir 
que duas transações nao alterem o saldo da conta ao mesmo tempo.

Edit1: Finalizei a implementação do GenServer neste domingo.

Finalização da implementação dos testes.

