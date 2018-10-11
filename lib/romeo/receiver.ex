defmodule Romeo.Receiver do
  @moduledoc """
    Simple module for representing messages

    This module allows catch received messages from mailbox
    instead of interaction with mailbox directly.
  """
  def recv_message() do
    recv_message([])
  end

  defp recv_message(messages) do
    receive do
      {
        :stanza,
        %Romeo.Stanza.Message{
          body: body,
          from: %Romeo.JID{user: fromUser, server: fromServer},
          to: %Romeo.JID{user: toUser, server: toServer}
        }
      } ->
        recv_message(messages) ++ [
          {
            fromUser <> "@" <> fromServer,
            toUser <> "@" <> toServer,
            body
          }
        ]
    after
      100 ->
        messages
    end
  end

end
