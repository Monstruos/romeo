defmodule Romeo.Register do
  @moduledoc false

  use Romeo.XML
  require Logger
# TODO: make exception

  def registration!(conn) do
    Logger.info fn -> "Registration started" end;
    registration(conn);
  end

  defp registration(
         %{
           transport: mod,
           nickname: username,
           password: password
         } = conn) do
#   TODO: make receive handler
    conn
    |> mod.send(Romeo.Stanza.get_inband_register())
    |> mod.recv(fn conn, xmlel(name: "iq") = elem ->
      conn
    end)
    |> mod.send(Romeo.Stanza.set_inband_register(username, password))
    |> mod.recv(fn conn, xmlel(name: "iq") ->
      conn
    end)
  end
end