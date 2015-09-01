Gateway
=======

A set of macros and conventions to build clients that communicate with REST apis

>Note: this is poorly tested (but still tested!) beta software, use at your own peril

HowTo: An Example
=================

We've been tasked with building a client library for Stripe's API.

We can do that easily using Gateway's macros like so:

In `lib/stripe.ex`, we use Gateway with a list of header and corresponding values.

Gateway automatically puts these things into `process_request_headers/1` method used by `HTTPoison.Base`
```elixir
defmodule Stripe do
  use Gateway, [{:Authorization, :secret_key}]
end
```

In `lib/stripe/account.ex`, we define what the remote resource would look like.

For the use case of Stripe's Account objects, the information can be found on Stripe's site: https://stripe.com/docs/api/curl#account_object

For clarity, we will only 4 fields. In future real gateway clients, we may want to include all the fields the foreign API service provides.
```elixir
defmodule Stripe.Account do
  defstruct [:id, :email, :display_name]
end
```

In `lib/stripe/accounts.ex`, we denote the `@endpoint` url and the `@resource`. If no `@resource` is specified, Gateway will automatically assume it's the singularized version of its current module.

Most companies expect the `update` method to be called with `put`, but in the case of Stripe, it is done with `post`. We specify that in the `use/2` macro.

Finally, we override Gateway's default `all_type/0`, on `all` requests to accounts, Stripe's response embeds the account data under the "data" field. We need to let gateway know how to handle this by redefining `all_type/0`
```elixir
defmodule Stripe.Accounts do
  @endpoint "/api/accounts/:id"
  @resource Stripe.Account
  use Gateway.Resource, update: :post

  def all_type, do: %{"data" => [@resource]}
end
```

Finally, `config/config.exs`, we define Stripe's host url, and our secret key.
```elixir
config :gateway, Stripe,
  url: "http://api.stripe.com",
  secret_key: "Bearer pk_my_secret_key"
```

And we are done (with Stripe's account API)! Use it like so:

```elixir
{:ok, account} = Stripe.Account.get "acc_231as"
# Retrives account id "acc_231as"

{:ok, accounts} = Stripe.Accounts.all
# Retrieves all accounts

{:ok, accounts} = Stripe.Accounts.all %{"some_search_param" => "some_value"}
# Retrives accounts according to your query (see Stripe's site for more details)

{:ok, account} = Stripe.Accounts.create %{"email" => "test@example.com", "other_fields" => "other_values"}
# Creates an account remotely on Stripe

{:ok, account} = account.id |> Stripe.Accounts.update(%{"email" => "another-email@example.com"})
# Updates an existing account on Stripe

{:ok, account} = account.id |> Stripe.Accounts.delete
# Deletes this account from Stripe
```

>note: the stripe library implemented this way lives at: 
> https://github.com/foxnewsnetwork/stripex