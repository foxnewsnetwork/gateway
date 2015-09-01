use Mix.Config

config :gateway, Simwms,
  url: "http://localhost:4000",
  master_key: "koudou ga yamu made soba ni iru nante tagaeru yakusoku ha sezu tada anata to itai"

config :gateway, Stripe,
  url: "https://api.stripe.com",
  secret_key: "Bearer sk_test_GINswumlSKmkYRJ3lnno7Cqx"