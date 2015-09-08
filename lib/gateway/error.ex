defmodule Gateway.Error do
  defstruct type: :unknown,
    url: "",
    raw: %{},
    reason: "",
    headers: [],
    status_code: 0
  def remote_error(%HTTPoison.Response{body: body, status_code: c, headers: headers}, url) do
    error = %__MODULE__{raw: body, status_code: c, headers: headers, type: :remote_error, url: url}
    reason = case c do
      400 -> "You were forbidden from making this request due to inappropriate parameters."
      404 -> "The resource you were looking for wasn't found on the remote server, you probably have a bad endpoint url."
      422 -> "You parameters were unprocessable by the remote server, reform them and try again."
      c when c >= 500 -> "Something is horribly wrong with the remote server"
      _ -> "Remote server rejected you for some reason"
    end
    %{error|reason: reason}
  end

  def http_error(%HTTPoison.Error{id: _id, reason: reason}=e, url) do
    %__MODULE__{raw: e, type: :http_error, reason: reason, url: url}
  end

  def parse_error(error, url) do
    %__MODULE__{raw: error, type: :parse_error, reason: "Unable to parse the response from the server", url: url}
  end
end