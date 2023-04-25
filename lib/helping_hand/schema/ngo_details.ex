defmodule HelpingHand.Schema.NgoDetails do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:uuid, :binary_id, autogenerate: true}
  schema "ngo_details" do
    field(:name, :string)
    field(:password, :string)
    field(:address, :string)
    field(:email, :string)
    field(:contact, :string)

    timestamps()
  end

  @doc false
  def changeset(site, attrs) do
    site
    |> cast(attrs, [
      :name,
      :password,
      :address,
      :email,
      :contact
    ])
    |> validate_required([:name, :password, :address, :email, :contact], message: "can't be blank")
  end
end
