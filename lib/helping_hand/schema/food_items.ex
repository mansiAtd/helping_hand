defmodule HelpingHand.Schema.FoodItems do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  schema "food_items" do
    field(:item, :string)
    field(:quantity, :string)
    field(:restaurant_id, :binary_id)

    belongs_to :restaurant_details, HelpingHand.Schema.Restaurants,
      foreign_key: :restaurant_id,
      references: :uuid,
      define_field: false

    timestamps()
  end

  @doc false
  def changeset(site, attrs) do
    site
    |> cast(attrs, [
      :item,
      :quantity
    ])
  end
end
