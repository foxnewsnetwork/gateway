defmodule Stripe.Customers do
  @resource Stripe.Customer
  @endpoint "/v1/customers/:id"
  use Gateway.Resource, update: :post
  
  def all_type, do: %{"data" => [@resource]}

end