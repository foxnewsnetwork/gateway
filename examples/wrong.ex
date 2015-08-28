defmodule Wrong do
  @moduledoc """
  The Wrong application is always wrong.

  I use it to for error tests
  """
  use HTTPoison.Base

  @spec process_url(String.t) :: String.t
  def process_url(path) do
    "http://localhost:6543" <> path
  end

end