defmodule Services.Mailer.LogAdapter do
  @behaviour Bamboo.Adapter

  alias Bamboo.Email
  require Logger

  def deliver(email, config) do
    body = email |> get_log_body(config) |> Poison.encode!()

    try do
      Logger.info(body, logger: "SentEmails")
    rescue
      _ ->
        Logger.error("Error sending email", logger: "SentEmails")
    end
  end

  @doc false
  def handle_config(config), do: config

  @doc false
  def supports_attachments?, do: false

  defp get_log_body(%Email{} = email, config) do
    email
    |> to_sendgrid_body(config)
    |> Map.update!(:content, fn content ->
      Enum.filter(content, &(&1.type == "text/plain"))
    end)
    |> Map.drop([:html_body, :assigns, :private])
  end

  defp to_sendgrid_body(%Email{} = email, config) do
    %{}
    |> put_from(email)
    |> put_personalization(email)
    |> put_reply_to(email)
    |> put_subject(email)
    |> put_content(email)
    |> put_template_id(email)
    |> put_attachments(email)
    |> put_categories(email)
    |> put_settings(config)
    |> put_asm_group_id(email)
    |> put_bypass_list_management(email)
  end

  defp put_from(body, %Email{from: from}) do
    Map.put(body, :from, to_address(from))
  end

  defp put_personalization(body, email) do
    Map.put(body, :personalizations, [personalization(email)])
  end

  defp personalization(email) do
    %{}
    |> put_to(email)
    |> put_cc(email)
    |> put_bcc(email)
    |> put_custom_args(email)
    |> put_template_substitutions(email)
    |> put_dynamic_template_data(email)
  end

  defp put_to(body, %Email{to: to}) do
    put_addresses(body, :to, to)
  end

  defp put_cc(body, %Email{cc: []}), do: body

  defp put_cc(body, %Email{cc: cc}) do
    put_addresses(body, :cc, cc)
  end

  defp put_bcc(body, %Email{bcc: []}), do: body

  defp put_bcc(body, %Email{bcc: bcc}) do
    put_addresses(body, :bcc, bcc)
  end

  defp put_reply_to(body, %Email{headers: %{"reply-to" => reply_to}}) do
    Map.put(body, :reply_to, %{email: reply_to})
  end

  defp put_reply_to(body, _), do: body

  defp put_subject(body, %Email{subject: subject}) when not is_nil(subject),
    do: Map.put(body, :subject, subject)

  defp put_subject(body, _), do: body

  defp put_content(body, email) do
    email_content = content(email)

    if not Enum.empty?(email_content) do
      Map.put(body, :content, content(email))
    else
      body
    end
  end

  defp put_settings(body, %{sandbox: true}),
    do: Map.put(body, :mail_settings, %{sandbox_mode: %{enable: true}})

  defp put_settings(body, _), do: body

  defp content(email) do
    []
    |> put_html_body(email)
    |> put_text_body(email)
  end

  defp put_html_body(list, %Email{html_body: nil}), do: list

  defp put_html_body(list, %Email{html_body: html_body}) do
    [%{type: "text/html", value: html_body} | list]
  end

  defp put_text_body(list, %Email{text_body: nil}), do: list

  defp put_text_body(list, %Email{text_body: text_body}) do
    [%{type: "text/plain", value: text_body} | list]
  end

  defp put_template_id(body, %Email{private: %{send_grid_template: %{template_id: template_id}}}) do
    Map.put(body, :template_id, template_id)
  end

  defp put_template_id(body, _), do: body

  defp put_template_substitutions(body, %Email{
         private: %{send_grid_template: %{substitutions: substitutions}}
       }) do
    Map.put(body, :substitutions, substitutions)
  end

  defp put_template_substitutions(body, _), do: body

  defp put_dynamic_template_data(body, %Email{
         private: %{send_grid_template: %{dynamic_template_data: dynamic_template_data}}
       }) do
    Map.put(body, :dynamic_template_data, dynamic_template_data)
  end

  defp put_dynamic_template_data(body, _), do: body

  defp put_custom_args(body, %Email{private: %{custom_args: custom_args}})
       when is_nil(custom_args) or length(custom_args) == 0,
       do: body

  defp put_custom_args(body, %Email{
         private: %{custom_args: custom_args}
       }) do
    Map.put(body, :custom_args, custom_args)
  end

  defp put_custom_args(body, _), do: body

  defp put_categories(body, %Email{private: %{categories: categories}})
       when is_list(categories) and length(categories) <= 10 do
    body
    |> Map.put(:categories, categories)
  end

  defp put_categories(body, _), do: body

  defp put_asm_group_id(body, %Email{private: %{asm_group_id: asm_group_id}})
       when is_integer(asm_group_id) do
    body
    |> Map.put(:asm, %{group_id: asm_group_id})
  end

  defp put_asm_group_id(body, _), do: body

  defp put_bypass_list_management(body, %Email{private: %{bypass_list_management: enabled}})
       when is_boolean(enabled) do
    mail_settings =
      body
      |> Map.get(:mail_settings, %{})
      |> Map.put(:bypass_list_management, %{enable: enabled})

    body
    |> Map.put(:mail_settings, mail_settings)
  end

  defp put_bypass_list_management(body, _), do: body

  defp put_attachments(body, %Email{attachments: []}), do: body

  defp put_attachments(body, %Email{attachments: attachments}) do
    transformed =
      attachments
      |> Enum.reverse()
      |> Enum.map(fn attachment ->
        %{
          filename: attachment.filename,
          type: attachment.content_type,
          content: "#Attachment.Content<>"
        }
      end)

    Map.put(body, :attachments, transformed)
  end

  defp put_addresses(body, _, []), do: body

  defp put_addresses(body, field, addresses),
    do: Map.put(body, field, Enum.map(addresses, &to_address/1))

  defp to_address({nil, address}), do: %{email: address}
  defp to_address({"", address}), do: %{email: address}
  defp to_address({name, address}), do: %{email: address, name: name}
end
