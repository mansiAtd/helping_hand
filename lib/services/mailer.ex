defmodule Services.Mailer do
  @moduledoc """
  A module allowing sending of emails using a third party API

  By levereging the Sendgrid API with [Bamboo](https://hexdocs.pm/bamboo/readme.html),
  the module allows for sending of emails.
  """
  use Bamboo.Mailer, otp_app: :helping_hand
end
