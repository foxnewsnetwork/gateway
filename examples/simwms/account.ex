defmodule Simwms.Account do
  @moduledoc """
  SimWMS account
  """
  @type t :: %Simwms.Account {
    id: String.t,
    permalink: String.t,
    service_plan_id: String.t,
    timezone: String.t,
    email: String.t,
    access_key_id: String.t,
    secret_access_key: String.t,
    region: String.t
  }
  defstruct [:id, 
    :permalink, 
    :service_plan_id, 
    :timezone, 
    :email, 
    :access_key_id, 
    :secret_access_key, 
    :region]
end