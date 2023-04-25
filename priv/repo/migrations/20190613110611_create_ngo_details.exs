defmodule HelpingHand.Repo.Migrations.NgoDetails do
  use Ecto.Migration

  def change do
    create table(:ngo_details, primary_key: false) do
      add(:uuid, :binary_id, primary_key: true)
      add(:name, :string)
      add(:password, :string)
      add(:address, :string)
      add(:email, :string)
      add(:contact, :string)

      timestamps()
    end
  end
end
