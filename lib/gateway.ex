defmodule Gateway do
  defmacro __using__(name_keys\\[]) do
    quote location: :keep do
      use HTTPoison.Base
      @gateway_config Application.get_env(:gateway, __MODULE__)

      def process_url(path) do
        @gateway_config[:url] <> path
      end
    
      def process_request_headers(headers) do
        unquote(name_keys)
        |> Enum.map(fn {name, key} -> {name, @gateway_config |> Dict.get(key)} end)
        |> Kernel.++(headers)
      end
    end
  end
end
