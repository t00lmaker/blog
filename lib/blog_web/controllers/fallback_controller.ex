defmodule  BlogWeb.FallbackController do

  use BlogWeb, :controller

  def call(conn, {:error, msg}) when is_binary(msg) do
    conn
    |> render("error_msg.html", msg: msg)
  end

end
