defmodule HelpingHandWeb.PageController do
  use HelpingHandWeb, :controller
  alias HelpingHand.HelpingHandService
  alias HelpingHand.Services.HelpingQueries

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def signup(conn, _params) do
    render(conn, "signup.html")
  end

  def sign_up(
        conn,
        params
      ) do
    email = params["email"]

    case {String.trim(params["ngo"]), String.trim(params["address"]),
          String.trim(params["contact"]), String.trim(params["email"]),
          String.trim(params["password"])} do
      {"", "", "", "", ""} ->
        conn
        |> put_flash(:error, "Fields are empty")
        |> redirect(to: "/signup")

      {"", _, _, _, _} ->
        conn
        |> put_flash(:error, "Please enter a valid ngo name")
        |> redirect(to: "/signup")

      {_, "", _, _, _} ->
        conn
        |> put_flash(:error, "Please enter address")
        |> redirect(to: "/signup")

      {_, _, "", _, _} ->
        conn
        |> put_flash(:error, "Please contact details")
        |> redirect(to: "/signup")

      {_, _, _, "", _} ->
        conn
        |> put_flash(:error, "empty_email")
        |> redirect(to: "/signup")

      {_, _, _, _, ""} ->
        conn
        |> put_flash(:error, "empty_password")
        |> redirect(to: "/signup")

      {trimmed_ngo, trimmed_address, trimmed_contact, trimmed_email, trimmed_password} ->
        details = %{
          ngo_name: trimmed_ngo,
          address: trimmed_address,
          contact: trimmed_contact,
          email: trimmed_email,
          password: trimmed_password
        }

        HelpingHandService.enter_ngo_details(details)

        restaurants = HelpingHandService.get_restaurants(email)
        render(conn, "restaurant.html", restaurants: restaurants, search_error: [])
    end
  end

  def restaurants(conn, params) do
    username = params["username"]
    password = params["password"]

    cond do
      String.length(username) == 0 || String.length(password) == 0 ->
        render(conn, "index.html",
          restaurants: [],
          search_error: "Please provide both username and password"
        )

      String.length(password) < 8 ->
        render(conn, "index.html",
          restaurants: [],
          search_error: "Please provide password with length greater than 8"
        )

      String.trim(username) != 0 &&
          !Regex.run(~r/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/, username) ->
        render(conn, "index.html",
          restaurants: [],
          search_error: "Please provide correct syntax of Username/Email"
        )

      !(HelpingQueries.validate_login_credentials(username, password) == password) ->
        render(conn, "index.html",
          restaurants: [],
          search_error: "Invalid username and password"
        )

      true ->
        restaurants = HelpingHandService.get_restaurants(username)

        render(conn, "restaurant.html",
          restaurants: restaurants,
          search_error: []
        )
    end
  end

  def restaurants_through_gmail(conn, %{"ngo_uuid" => ngo_uuid}) do
    restaurants = HelpingHandService.get_restaurants(ngo_uuid)
    render(conn, "restaurant.html", restaurants: restaurants)
  end

  def get_food_items_list(conn, %{"restaurant_uuid" => restaurant_uuid, "ngo_uuid" => ngo_uuid}) do
    food_items =
      HelpingHandService.get_food_items(restaurant_uuid)
      |> Enum.map(fn f -> Map.put(f, :restaurant_uuid, restaurant_uuid) end)
      |> Enum.map(fn f -> Map.put(f, :ngo_uuid, ngo_uuid) end)

    render(conn, "food_items.html", food_items: food_items)
  end

  def place_order_and_send_email(conn, %{
        "ngo_uuid" => ngo_uuid,
        "restaurant_uuid" => restaurant_uuid
      }) do
    uuids = %{
      ngo_uuid: ngo_uuid,
      restaurant_uuid: restaurant_uuid
    }

    HelpingHandService.send_email_to_restaurant(ngo_uuid, restaurant_uuid)
    render(conn, "order_placed.html", uuids: uuids)
  end
end
