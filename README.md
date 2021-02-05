# SafeFinance

SafeFinance é um microserviço para realizar transações sem pontos flutuantes em uma moeda. Um desafio proposto como teste técnico pela [Stone.co](https://www.stone.co/br/).

* [Instalação](https://github.com/rik471/safe-finance#instala%C3%A7%C3%A3o)
* [Testes](https://github.com/rik471/safe-finance#Testes)
* [Ações e Fluxo da API](https://github.com/rik471/safe-finance#a%C3%A7%C3%B5es-e-fluxo-da-api)
* [Rotas](https://github.com/rik471/safe-finance#rotas)
  
  * [Signup](https://github.com/rik471/safe-finance#signup)
  * [Show User](https://github.com/rik471/safe-finance#show-user)
  * [List Users](https://github.com/rik471/safe-finance#list-users)
  * [Transaction](https://github.com/rik471/safe-finance#transaction)
  * [Update Balance](https://github.com/rik471/safe-finance#update-balance)

## Instalação

Para ultilizar o microserviço, é preciso ter [Elixir](https://elixir-lang.org/install.html), [Phoenix](https://hexdocs.pm/phoenix/installation.html) e [PostgreSql](https://www.postgresql.org/).

* Instale as dependencias `mix deps.get`
* Crie o banco de dados e sua estrutura `mix ecto.setup`
* Inicie o Phoenix em ambiente localhost `mix phx.server`

Para acessar as rotas visite [`localhost:4000`](http://localhost:4000)`/api` do seu navegador, [Insomnia](https://insomnia.rest/download/) ou [Postman](https://www.postman.com/).

Agora você está pronto! :smile:

## Testes

* Rode os testes da aplicação ultilizando o comando `mix test`

* Ultilize o comando `MIX_ENV=test mix coveralls` para rodar os testes mostrando a cobertura dos testes no código.

## Ações e Fluxo da API

Primeiramente, para ultilização a API é necessário criar dois usuários para realizar transfêrencias, uma para conta origem e outra para conta destino. 
A conta deve conter um nome, email e senha*, tendo sucesso ela recebe um id da conta que pode ser ultilizado para realizar transações.

Depois de criado a conta você pode adicionar saldo pela rota `api/update/balance` e transferir para outra conta utilizando `api/operations/transaction`

## Rotas

### Signup

rota: `api/users/signup`

type: `POST`

**Request Params**
 
* Email: `email string`

* Nome: `name string`

* Senha: `password string`

**Body Params (JSON)**

```json
{
  "user": {
    "name": "Rick",
    "email": "rick@mail.com",
    "password": "123456"
  }
}
```

**Response**

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

*Obs: O campo senha embora não exista autenticação foi apenas implementado para mostrar a segurança de senha possível por criar uma hash do mesmo campo.

### Show User

Note que nos *headers* da rota `signup`, em *location* contém uma rota onde acessando, é encontrado os dados do usuário e conta criada 

rota: `api/users/show?id={id}` 

type: `GET`

### List Users

A medida que cria novos usuários poderá ver uma listagem de todos para consulta em:

Rota: `api/users/list`

Type: `GET`

### Transaction

Rota: `api/operations/transaction`

Type: `PUT`

**Body params (JSON)**

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

**Reponse**
```json
{
  "message": "Transaction was sucessfull! From: 3fe295cd-9fab-43fb-806f-5d7430250cbe To: 94f35f36-9a2a-418e-af26-d1bbeb1adfc9 Value: 10"
}
```
Note na rota de listagem (`api/users/list`), ou na rota de mostrar um usuario (`api/users/show?id={id}`) que o valor foi abatido da conta de origem e acrescentado na conta de destino.

### Update Balance

Rota: `api/operations/update/balance`

Type: `PUT`

**Request  params (JSON)**

* Conta a ser adicionada balance: `account_id string`

* Valor (balance) a ser adicionado a conta: `value string`

**Body Params (JSON)**
```json
{
  "account_id": "3fe295cd-9fab-43fb-806f-5d7430250cbe",
  "value": "10"
}
```

**Response**
```json
{
  "message": "Account amount updated!",
  "account_id": "3fe295cd-9fab-43fb-806f-5d7430250cbe",
  "value": "10"
}