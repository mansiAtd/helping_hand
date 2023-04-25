defmodule HelpingHand.Repo do
  use Ecto.Repo,
    otp_app: :helping_hand,
    adapter: Ecto.Adapters.Postgres
end
