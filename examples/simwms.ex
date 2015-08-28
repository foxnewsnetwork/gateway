defmodule Simwms do
  @moduledoc """
  Here, Simwms is an ActiveModel-like api living on my local machine

  If you're not me, you probably won't be able to pass the tests involing this. Sorry.
  """
  use Gateway, [{"simwms-master-key", :master_key}]
  # use HTTPoison.Base
  # @simwms_config Application.get_env(:gateway, :simwms)

  # @spec process_url(String.t) :: String.t
  # def process_url(path) do
  #   @simwms_config[:url] <> path
  # end

  # @spec process_request_headers(map) :: map
  # def process_request_headers(headers) do
  #   [{"simwms-master-key", @simwms_config[:master_key]}] ++ headers
  # end
end