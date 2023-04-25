defmodule HelpingHand.Repo.Migrations.FoodItemsDetails do
  use Ecto.Migration

  def change do
    create table(:food_items) do
      add(:item, :string)
      add(:quantity, :string)

      add(
        :restaurant_id,
        references(:restaurant_details, column: :uuid, type: :binary_id, on_delete: :nothing)
      )

      timestamps()
    end
  end
end
