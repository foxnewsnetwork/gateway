defmodule Stripe.Customer do
  defstruct          id: "",
                  email: "",
                 object: "customer",
                created: 0,
               livemode: false,
            description: "",
             delinquent: false,
               metadata: %{},
          subscriptions: [],
               discount: nil,
        account_balance: 0,
               currency: "usd",
                  cards: [],
           default_card: nil
end