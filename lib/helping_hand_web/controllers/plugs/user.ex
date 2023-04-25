defmodule HelpingHandWeb.Plugs.SetUser do
  import Plug.Conn

  alias HelpingHand.Repo
  alias HelpingHand.Schema.User

  def init(_params) do
  end

  def call(conn, _params) do
    # get user_id from the session
    user_id = get_session(conn, :user_id)

    cond do
      # check if user exists in database and assign to user variable
      user = user_id && Repo.get(User, user_id) ->
        # now assign user struct to the conn object
        assign(conn, :user, user)

      true ->
        # user not found in database, return nil, and conn object is un-changed.
        assign(conn, :user, nil)
    end
  end
end
