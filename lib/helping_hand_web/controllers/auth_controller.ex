defmodule HelpingHandWeb.AuthController do
  use HelpingHandWeb, :controller
  # alias HelpingHandWeb.Router.Helpers
  alias HelpingHand.Schema.User
  alias HelpingHand.Repo

  @derive Poison

  plug Ueberauth
  #
  # alias Ueberauth.Strategy.Helpers

  def create(
        %{assigns: %{ueberauth_auth: auth}} = conn,
        _params
      ) do
    user_params = %{token: auth.credentials.token, email: auth.info.email, provider: "google"}
    changeset = User.changeset(%User{}, user_params)

    # signin(conn, changeset)
    case insert_or_update_user(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "")
        |> put_session(:user_id, user.id)
        |> redirect(to: "/restaurants/user.id")

      {:error, _reason} ->
        conn
        |> put_flash(:error, "error signing in")
        |> redirect(to: "/")
    end
  end

  def signout(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end

  defp insert_or_update_user(changeset) do
    case Repo.get_by(User, email: changeset.changes.email) do
      nil ->
        Repo.insert(changeset)

      user ->
        {:ok, user}
    end
  end
end
