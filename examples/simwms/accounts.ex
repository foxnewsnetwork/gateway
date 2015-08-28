defmodule Simwms.Accounts do
  @endpoint "/internal/accounts/:id"
  @resource Simwms.Account
  use Gateway.Resource

  def retrieve_type, do: %{"account" => @resource}
  def all_type, do: %{"accounts" => [@resource]}
end