# Desafio Backend Stone


Projeto configurado para iniciar utilizando o docker-compose, com uma imagem do Elixir:latest, e a instalação do Phoenix 1.4.11, e uma imagem do Postgres.
Para iniciar o projeto localmente `docker-compose up`

O deploy foi realizado utilizando o Gigalexir (https://gigalixir.com/) e para CD foi utilizado o GitHub Actions

Link para a documentacao da API: https://documenter.getpostman.com/view/5027528/SWE9Zx5s?version=latest#e59fc4b3-6cdd-4100-974f-b4a6c9ee3be8

Link para a api publicada: https://lightslategray-stylish-catbird.gigalixirapp.com/

A documentacao gerada se encontra em doc/index.html

Obs.:
Ficaram dois itens pendentes:

Finalizacao da implementacao do Genserver para processar as transacoes em fila, utilizando uma fila por conta, para garantir que duas transacoes nao alterem o saldo da mesma conta.

Finalizacao da implementacao dos testes.

