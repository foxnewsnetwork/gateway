defmodule Wrong.Horses do
  @endpoint "/api/horses/:id"
  @resource Wrong.Horse
  use Gateway.Resource
end