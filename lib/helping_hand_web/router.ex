defmodule HelpingHandWeb.Router do
  use HelpingHandWeb, :router
  require Ueberauth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug HelpingHandWeb.Plugs.SetUser
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  forward("/sent_emails", Bamboo.SentEmailViewerPlug)

  scope "/", HelpingHandWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/signup", PageController, :signup
    post "/sign_up", PageController, :sign_up
    post "/restaurants", PageController, :restaurants

    get "/restaurants/:ngo_uuid", PageController, :restaurants_through_gmail
    get "/food_items_list/:restaurant_uuid/:ngo_uuid", PageController, :get_food_items_list
    get "/order_place", PageController, :order_place
    get "/signout", AuthController, :signout

    get "/order_place/:restaurant_uuid/:ngo_uuid",
        PageController,
        :place_order_and_send_email
  end

  # RanqWeb is app namespace
  scope "/auth", HelpingHandWeb do
    pipe_through :browser
    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :create
  end

  # Other scopes may use custom stacks.
  # scope "/api", HelpingHandWeb do
  #   pipe_through :api
  # end
end
