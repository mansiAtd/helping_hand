defmodule HelpingHand.Services.HelpingQueries do
  alias HelpingHand.Repo
  alias Ecto.Multi

  alias HelpingHand.Schema.{
    FoodItems,
    NgoDetails,
    Restaurants
  }

  import Ecto.Query

  def get_ngo_details(ngo_uuid) do
    Repo.one(
      from g in NgoDetails,
        where: g.uuid == ^ngo_uuid
    )
  end

  def get_ngo_uuid(email) do
    from(ng in NgoDetails,
      where: ng.email == ^email,
      select: %{ngo_uuid: ng.uuid}
    )
    |> Repo.one()
  end

  def get_restaurants() do
    from(
      r in Restaurants,
      distinct: true,
      left_join: fi in FoodItems,
      on: r.uuid == fi.restaurant_id,
      select: %{
        restaurant_name: r.name,
        restaurant_address: r.address,
        restaurant_contact_no: r.contact,
        restaurant_uuid: r.uuid
      },
      order_by: r.name
    )
    |> Repo.all()
  end

  def get_food_items_by_restaurant_uuid(restaurant_uuid) do
    from(
      fi in FoodItems,
      inner_join: r in Restaurants,
      on: fi.restaurant_id == r.uuid,
      where: r.uuid == ^restaurant_uuid,
      select: %{
        item: fi.item,
        quantity: fi.quantity,
        restaurant_name: r.name,
        restaurant_id: fi.restaurant_id,
        restaurant_email: r.email
      }
    )
    |> Repo.all()
  end

  def validate_login_credentials(user_name, password) do
    from(
      p in NgoDetails,
      where: p.email == ^user_name,
      select: p.password
    )
    |> Repo.one()
  end

  def enter_ngo_details(details) do
    %NgoDetails{}
    |> NgoDetails.changeset(%{
      name: details.ngo_name,
      password: details.password,
      address: details.address,
      email: details.email,
      contact: details.contact
    })
    |> Repo.insert()
  end
end
