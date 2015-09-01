defmodule Stripe do
  @moduledoc """
  The stripe example here can be found in a more complete form at:

  https://github.com/foxnewsnetwork/stripex

  If you actually intend on using the Stripe API,
  I highly recommend using that particular library
  """
  use Gateway, [{:Authorization, :secret_key}]
end