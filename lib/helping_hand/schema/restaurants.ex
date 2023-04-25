defmodule HelpingHand.Schema.Restaurants do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:uuid, :binary_id, autogenerate: true}
  schema "restaurant_details" do
    field :name, :string
    field :address, :string
    field :email, :string
    field :contact, :string
    timestamps()
  end

  @doc false
  def changeset(site, attrs) do
    site
    |> cast(attrs, [
      :name,
      :address,
      :email,
      :contact
    ])
  end
end
