# SafeFinance

SafeFinance é um microserviço para realizar transações sem pontos flutuantes em uma moeda. Um desafio proposto como teste técnico pela [Stone.co](https://www.stone.co/br/).

* [Instalação](https://github.com/rik471/safe-finance#instala%C3%A7%C3%A3o)
* [Ações e Fluxo da API](https://github.com/rik471/safe-finance#a%C3%A7%C3%B5es-e-fluxo-da-api)
* [Testes](https://github.com/rik471/safe-finance#a%C3%A7%C3%B5es-e-fluxo-da-api)

## Instalação:

Para consumir o microserviço, é preciso ter Elixir, Phoenix e PostgreSql.

* Instale as dependencias com o comando `mix deps.get`
* Crie o banco de dados e sua estrutura com `mix ecto.setup`
* Inicie o Phoenix em ambiente localhost com `mix phx.server`

Para acessar as rotas visite [`localhost:4000`](http://localhost:4000)`/api` do seu navegador, Insomnia ou Postman.

Agora você está pronto :smile:

## Ações e Fluxo da API

Primeiramente, para ultilização a API é necessário criar dois usuário para realizar transfêrencias, uma para conta origem e outra para conta destino. 
A conta deve conter um nome, email e senha*.

Faça isso ultilizando o seguinte endpoint:

Rota: `api/users/signup`

Type: `POST`

### Body params (JSON)
 
* Email: `email string`

* Nome: `name string`

* Senha: `password string`

**Request**

```json
{
  "user": {
    "name": "Rick",
    "email": "rick@mail.com",
    "password": "123456"
  }
}
```

A resposta será um usuário criado e uma conta com os valores padrão como abaixo

**Resposta**

``` json
{
  "balance": 1000,
  "currency": "BRL",
  "user": {
    "email": "rick@mail.com",
    "id": "8d1da1d5-8276-4934-92b1-772c0545c574",
    "name": "Rick",
    "password_hash": "$argon2id$v=19$m=131072,t=8,p=4$WiIHo8c0Oio+clvObXflxQ$yhpHKQ+mO8qbcY1FBP1i4YWThWK1ZUA8ewscyYWe1zo"
  }
}
```
Note que nos headers dessa requisição, contém uma rota para `GET api/users/show?id={id}` onde acessando, é encontrado os dados do usuário e conta criados

*Obs: O campo senha embora não exista autenticação foi apenas implementado para mostrar a segurança de senha possível por criar uma hash do mesmo campo.

A medida que cria novos usuários poderá ver uma listagem de todos para consulta em:

Rota: `api/users/list`

Type: `GET`

**Após criar dois usuário será possível fazer uma transferência de uma conta para outra, do seguinte modo:**

Rota: `api/operations/transaction`

Type: `PUT`

### Body params (JSON)

* Id da conta origem: `from_account_id string`

* Id da conta destino: `to_account_id string`

Valor: `value string` , o valor será string para que não haja pontos flutuantes.

Lembre-se de ultilizar o id da conta do usuário e não o id do usuário ao realizar transações.

**Request**

``` json
{
  "from_account_id": "3fe295cd-9fab-43fb-806f-5d7430250cbe",
  "to_account_id": "94f35f36-9a2a-418e-af26-d1bbeb1adfc9",
  "value": "10"
}
```

**Reposta**
```json
{
  "message": "Transaction was sucessfull! From: 3fe295cd-9fab-43fb-806f-5d7430250cbe To: 94f35f36-9a2a-418e-af26-d1bbeb1adfc9 Value: 10"
}
```
Note na rota de listagem (`api/users/list`), ou na rota de mostrar um usuario (`api/users/show?id={id}`) que o valor foi abatido da conta de origem e acrescentado na conta de destino.

**Por fim, para inserir mais valores em uma conta ultilize a rota de atualizar a conta da seguinte forma:**

Rota: `api/operations/update/balance`

Type: `PUT`

### Body  params (JSON)

* Conta a ser adicionada balance: `account_id string`

* Valor (balance) a ser adicionado a conta: `value string`

### Testes

* Rode os testes da aplicação ultilizando o comando `mix test`

* Ultilize o comando `MIX_ENV=test mix coveralls` para rodar os testes mostrando a cobertura dos testes no código.
