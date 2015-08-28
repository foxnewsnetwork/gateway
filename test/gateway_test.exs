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
end
