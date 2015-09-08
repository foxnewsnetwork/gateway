defmodule Gateway.Response do
  
  def cast_as({:error, error}, _, url) do
    {:error, Gateway.Error.http_error(error, url)}
  end

  def cast_as({:ok, response}, type, url) do
    case response |> extract_body(url) do
      {:ok, body} -> body |> parse(type, url)
      {:error, error} -> {:error, error}
    end
  end

  def extract_body(%{status_code: code, body: body}, _) when 200 <= code and code <= 202 do
    {:ok, body}
  end

  def extract_body(response, url) do
    {:error, Gateway.Error.remote_error(response, url)}
  end

  def parse(body, type, url) do
    case body |> Poison.decode(as: type) do
      {:ok, results} -> {:ok, results}
      error -> {:error, Gateway.Error.parse_error(error, url)}
    end
  end
end