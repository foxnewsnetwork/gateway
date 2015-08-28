defmodule Gateway.Extractor do
  @moduledoc """
  The extractor is necessary because Poison occasionally casts jsons as nested maps.

  The extractor throws away useless information and gets to the models we're interested in.

  ## Examples
      poison_result = {:ok, %{"data" => [%MyClient.Account{}, %MyClient.Account{}]}}
      poison_result |> extract_model(%{"data" => [MyClient.Account]})
      # {:ok, [%MyClient.Account{}, %MyClient.Account{}]}
  """
  defstruct nothing_to_do?: true,
    key: "",
    reduced_extractor: nil
  @type extractable_type :: atom | [atom] | %{String.t => extractable_type}

  def extract({:error, _}=e, _), do: e
  def extract({:ok, buried_model}, type_spec) do
    buried_model |> extract(parse! type_spec)
  end
  def extract(buried_model, extractor) do
    if extractor.nothing_to_do? do
      {:ok, buried_model}
    else
      buried_model
      |> Dict.fetch!(extractor.key)
      |> extract(extractor.reduced_extractor)
    end
  end

  def parse!(atom) when is_atom(atom) do
    %__MODULE__{}
  end

  def parse!([atom]) when is_atom(atom) do
    atom |> parse!
  end

  def parse!(map) when is_map(map) do
    map |> Map.to_list |> parse!
  end

  def parse!([{key, type_spec}]) when is_binary(key) do
    extractor = type_spec |> parse!
    %__MODULE__{nothing_to_do?: false, key: key, reduced_extractor: extractor}
  end

  def parse!(malformed_type) do
    throw """
    A proper type_spec looks something like:
      MyClient.Account
      [MyClient.Account]
      %{"data" => [MyClient.Account]}

    The horseshit you gave me:
      #{malformed_type}

    could not be parsed, so please fix it (be sure to use string keys).
    """
  end
end