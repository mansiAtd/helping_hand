defmodule HelpingHand.HelpingHandService do
  alias HelpingHand.Services.HelpingQueries
  alias Services.Mailer
  use Bamboo.Phoenix, view: EIS.EmailView

  def enter_ngo_details(details) do
    HelpingQueries.enter_ngo_details(details)
  end

  def get_restaurants(username) do
    ngo_uuid =
      case HelpingQueries.get_ngo_uuid(username) do
        nil -> %{ngo_uuid: username}
        ngo_uuid -> ngo_uuid
      end

    HelpingQueries.get_restaurants() |> Enum.map(fn res -> Map.merge(res, ngo_uuid) end)
  end

  def get_food_items(restaurant_uuid) do
    HelpingQueries.get_food_items_by_restaurant_uuid(restaurant_uuid)
  end

  def send_email_to_restaurant(ngo_uuid, restaurant_uuid) do
    ngo_details = HelpingQueries.get_ngo_details(ngo_uuid)
    food_details = get_food_items(restaurant_uuid)
    restaurant_name = food_details |> Enum.map(& &1.restaurant_name) |> List.first()
    restaurant_email = food_details |> Enum.map(& &1.restaurant_email) |> List.first()

    food_items = food_details |> Enum.map(& &1.item)

    details = %{
      ngo_name: ngo_details.name,
      ngo_contact: ngo_details.contact,
      ngo_address: ngo_details.address,
      food_items: food_items,
      restaurant_name: restaurant_name
    }

    send_email(restaurant_email, details)
  end

  defp send_email(restaurant_email, details) do
    email =
      new_email()
      |> to(restaurant_email)
      |> from("helping-hand-noreply@gmail.com")
      |> subject("New Order from #{details.ngo_name}")
      |> put_layout({HelpingHandWeb.EmailView, :send_email})
      |> assign(:details, details)
      |> render(:email_with_assigns)

    Mailer.deliver_now(email)
  end
end
