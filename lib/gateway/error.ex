defmodule Gateway.Error do
  defstruct type: :unknown,
    raw: %{},
    reason: "",
    headers: [],
    status_code: 0
  def remote_error(%HTTPoison.Response{body: body, status_code: c, headers: headers}) do
    error = %__MODULE__{raw: body, status_code: c, headers: headers, type: :remote_error}
    reason = case c do
      400 -> "You were forbidden from making this request due to inappropriate parameters."
      422 -> "You parameters were unprocessable by the remote server, reform them and try again."
      c when c >= 500 -> "Something is horribly wrong with the remote server"
      _ -> "Remote server rejected you for some reason"
    end
    %{error|reason: reason}
  end

  def http_error(%HTTPoison.Error{id: _id, reason: reason}=e) do
    %__MODULE__{raw: e, type: :http_error, reason: reason}
  end

  def parse_error(error) do
    %__MODULE__{raw: error, type: :parse_error, reason: "Unable to parse the response from the server"}
  end
end