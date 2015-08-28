defmodule Gateway.Response do
  
  def cast_as({:error, error}, _) do
    {:error, Gateway.Error.http_error(error)}
  end

  def cast_as({:ok, response}, type) do
    case response |> extract_body do
      {:ok, body} -> body |> parse(type)
      {:error, error} -> {:error, error}
    end
  end

  def extract_body(%{status_code: code, body: body}) when 200 <= code and code <= 202 do
    {:ok, body}
  end

  def extract_body(response) do
    {:error, Gateway.Error.remote_error(response)}
  end

  def parse(body, type) do
    case body |> Poison.decode(as: type) do
      {:ok, results} -> {:ok, results}
      error -> {:error, Gateway.Error.parse_error(error)}
    end
  end
end