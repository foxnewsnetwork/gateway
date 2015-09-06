defmodule Gateway do
  defmacro __using__(name_keys\\[]) do
    quote location: :keep do
      use HTTPoison.Base

      def gateway_config do
        Application.get_env(:gateway, __MODULE__)
      end

      def process_url(path) do
        gateway_config[:url] |> Path.join(path)
      end
    
      def process_request_headers(headers) do
        unquote(name_keys)
        |> Enum.map(fn {name, key} -> {name, gateway_config |> Dict.get(key)} end)
        |> Kernel.++(headers)
      end
    end
  end
end
