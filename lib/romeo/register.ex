defmodule Romeo.Register do
  @moduledoc false

  use Romeo.XML
  require Logger
  defmodule Error do
    defexception [:message]

    def exception(reason) do
      msg = "Registration failed: #{inspect reason}"
      %Romeo.Register.Error{message: msg}
    end
  end

  def registration!(conn) do
    Logger.info fn -> "Registration started" end;
    registration(conn)
  end

  defp registration(
         %{
           transport: mod,
           nickname: username,
           password: password
         } = conn) do
    conn = conn
           |> mod.send(Romeo.Stanza.get_inband_register())
           |> mod.recv(fn conn, xmlel(name: "iq", attrs: attrs) = elem ->
      case List.keyfind(attrs, "type", 0) do
        {"type", "result"} ->
          conn
        _ ->
          raise Romeo.Register.Error, elem
      end
    end)
           |> mod.send(Romeo.Stanza.set_inband_register(username, password))
           |> mod.recv(fn conn, xmlel(name: "iq", attrs: attrs) = elem ->
      case List.keyfind(attrs, "type", 0) do
        {"type", "result"} ->
          conn
        _ ->
          raise Romeo.Register.Error, elem
      end
    end)
    conn
  end
end