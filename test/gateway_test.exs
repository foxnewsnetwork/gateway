defmodule GatewayTest do
  use ExUnit.Case

  test "the truth" do
    assert 1 + 1 == 2
  end
  @account_attr %{
    "service_plan_id" => "test",
    "timezone" => "Americas/Los_Angeles",
    "email" => "test@test.test",
    "access_key_id" => "666hailsatan",
    "secret_access_key" => "ikitsu you na planetarium",
    "region" => "Japan"
  }
  test "simwms create valid" do
    {:ok, account} = Simwms.Accounts.create account: @account_attr
    assert account.id
    assert account.service_plan_id == "test"
    assert account.email == "test@test.test"
  end

  test "simwms create invalid" do
    {:error, error} = Simwms.Accounts.create %{}
    assert error
    assert error.type == :remote_error
    assert error.status_code == 400
    assert error.reason =~ "forbidden"
  end

  test "wrong create invalid" do
    {:error, error} = Wrong.Horses.create %{}
    assert error
    assert error.reason == :econnrefused
    assert error.type == :http_error
  end

  @customer_attr %{ 
    email: "gateway.spec@#{Fox.StringExt.random(10)}.co",
    description: "stripex testing customer",
    metadata: %{
      "now_playing" => "Halycon",
      "artist" => "Reol",
      "genre" => "Jpop"
    }
  }
  test "creating a customer, getting a customer, updating a customer, deleting a customer" do
    {:ok, customer} = Stripe.Customers.create @customer_attr
    id = customer.id
    assert id
    assert customer.email == @customer_attr[:email]
    assert customer.description == @customer_attr[:description]
    assert customer.metadata == @customer_attr[:metadata]

    {:ok, customer} = Stripe.Customers.retrieve id
    assert customer.id == id

    {:ok, customer} = Stripe.Customers.update(id, %{email: "dog@do.ge"})
    assert customer.email == "dog@do.ge"

    {:ok, dead_customer} = customer.id |> Stripe.Customers.delete
    assert dead_customer.id == customer.id
  end

  test "it should properly not find stuff" do
    {:error, error} = Stripe.Customers.retrieve "掴めないものほど欲しくなる"
    assert error.status_code == 404
  end
end
