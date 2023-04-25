defmodule HelpingHand.Repo.Migrations.RestaurantDetails do
  use Ecto.Migration

  def change do
    create table(:restaurant_details, primary_key: false) do
      add(:uuid, :binary_id, primary_key: true)
      add(:name, :string)
      add(:address, :string)
      add(:email, :string)
      add(:contact, :string)

      timestamps()
    end

    create(unique_index(:restaurant_details, [:uuid]))
  end
end
