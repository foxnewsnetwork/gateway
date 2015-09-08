defmodule Gateway.Resource do
  @moduledoc """
  Resources are the core of any REST api. Use this module in your resource collections to enable the remote calls.

  ## Examples
      defmodule MyClient.Account do
        @type t :: %MyClient.Account { id: String.t, email: String.t, other_fields: String.t }
        defstruct :id, :email, :other_fields
      end

      defmodule MyClient.Accounts do
        @endpoint "/api/users/:user_id/accounts/:id"
        use Gateway.Resource
      end
  """
  @defaults %{
    retrieve: :get,
    all: :get,
    create: :post,
    update: :put,
    delete: :delete
  }

  @doc """
  Attempts to guess the resource name of the atom given.

  The resource name is the singularized version of the given atom
  """
  def infer_resouce_name(atom) do
    atom
    |> Atom.to_string
    |> Fox.StringExt.singularize
    |> String.to_existing_atom
  end
  
  defmacro __using__(opts\\%{}) do
    methods = Dict.merge @defaults, opts
    quote location: :keep do
      @resource Module.get_attribute(__MODULE__, :resource) || Gateway.Resource.infer_resouce_name(__MODULE__)
      @doc """
      The "show" action.
      Retrieves the remote resource with the given id(s).

      ## Examples
          defmodule MyClient.Accounts do
            use Gateway.Resource
          end

          MyClient.Accounts.retrieve(4)
          # {:ok, %MyClient.Account{id: 4, other_fields: "stuff"} }
      """
      def retrieve(ids) when is_tuple(ids) do
        path = resource_path(ids)
        apply(specific_gateway, unquote(methods[:retrieve]), [path])
        |> Gateway.Response.cast_as(retrieve_type, path)
        |> Gateway.Extractor.extract(retrieve_type)
      end
      def retrieve(id), do: retrieve({id})
      def retrieve_type, do: @resource

      @doc """
      The "index" action
      Returns all the remote resources of a type

      ## Examples
          defmodule MyClient.Accounts do
            use Gateway.Resource
          end

          MyClient.Accounts.all
          # {:ok, [%MyClient.Account{id: 4, other_fields: "stuff"}]}
      """
      def all, do: all({}, %{})
      def all(ids, params) when is_tuple(ids) and (is_list(params) or is_map(params)) do
        path = resource_path(ids, params)
        apply(specific_gateway, unquote(methods[:all]), [path])
        |> Gateway.Response.cast_as(all_type, path)
        |> Gateway.Extractor.extract(all_type)
      end
      def all(ids) when is_tuple(ids) do
        all(ids, %{})
      end
      def all(id) when is_binary(id) or is_integer(id) do
        all({id}, %{})
      end
      def all(params) when is_map(params) or is_list(params) do
        all({}, params)
      end
      def all_type, do: %{"data" => [@resource]}

      @doc """
      Posts to the create action
      Creates a resource on a remote api

      ## Examples
          defmodule MyClient.Accounts do
            use Gateway.Resource
          end

          MyClient.Accounts.create(%{email: "user@example.co"})
          # {:ok, %MyClient.Account{id: 4, email: "user@example.co", other_fields: "stuff"}}
      """
      def create, do: create({}, %{})
      def create(ids, list) when is_tuple(ids) and (is_list(list) or is_map(list)) do
        list = Fox.DictExt.shallowify_keys list
        path = resource_path(ids)

        apply(specific_gateway, unquote(methods[:create]), [path, {:form, list}, [content_type: "multipart/form-data"]])
        |> Gateway.Response.cast_as(create_type, path)
        |> Gateway.Extractor.extract(create_type)
      end
      def create(id, list), do: create({id}, list)
      def create(id) when is_binary(id) do
        create({id}, %{})
      end
      def create(list), do: create({}, list)
      def create_type, do: retrieve_type

      @doc """
      Puts to the update action
      Updates a resource on a remote api

      ## Examples
          defmodule MyClient.Accounts do
            use Gateway.Resource
          end

          account.id |> MyClient.Accounts.update(%{email: "user@example.co"})
          # {:ok, %MyClient.Account{id: 4, email: "user@example.co", other_fields: "stuff"}}
      """
       def update(ids, params) when is_tuple(ids) and (is_list(params) or is_map(params)) do
        list = Fox.DictExt.shallowify_keys params

        path = resource_path(ids)
        apply(specific_gateway, unquote(methods[:update]), [path, {:form, list}, [content_type: "multipart/form-data"]])
        |> Gateway.Response.cast_as(update_type, path)
        |> Gateway.Extractor.extract(update_type)
      end
      def update(id, params), do: update({id}, params)
      def update_type, do: retrieve_type

      @doc """
      Deletes to the delete action
      Deletes a resource from a remote api

      ## Examples
          defmodule MyClient.Accounts do
            use Gateway.Resource
          end

          account.id |> MyClient.Accounts.delete
          # {:ok, %MyClient.Account{id: 4, email: "user@example.co", other_fields: "stuff"}}
      """
      def delete(ids) when is_tuple(ids) do
        path = resource_path(ids)
        apply(specific_gateway, unquote(methods[:delete]), [path])
        |> Gateway.Response.cast_as(delete_type, path)
        |> Gateway.Extractor.extract(delete_type)
      end
      def delete(id), do: delete({id})
      def delete_type, do: retrieve_type

      defp specific_gateway do
        __MODULE__
        |> Atom.to_string
        |> String.split(".")
        |> Enum.slice(0..-2)
        |> Enum.join(".")
        |> String.to_existing_atom
      end

      defp resource_path(ids) when is_tuple(ids) do
        @endpoint |> Fox.UriExt.fmt(ids) |> String.replace(~r/\/:id$/, "", global: false)
      end
      defp resource_path(ids, params) when is_tuple(ids) and (is_list(params) or is_map(params)) do
        query_string = Fox.UriExt.encode_query params
        "#{resource_path(ids)}?#{query_string}"
      end
      defp resource_path(params), do: resource_path({}, params)

      defoverridable [retrieve_type: 0, all_type: 0, create_type: 0, update_type: 0, delete_type: 0, resource_path: 1, resource_path: 2]
    end
  end
end
