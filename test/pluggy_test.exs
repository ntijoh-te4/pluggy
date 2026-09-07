defmodule PluggyTest do
  use ExUnit.Case
  import Plug.Test
  import Plug.Conn

  @opts Pluggy.Router.init([])

  test "GET /fruits/new renders the new fruit form" do
    conn =
      conn(:get, "/fruits/new")
      |> Pluggy.Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body =~ "<form"
  end

  test "unknown routes respond with 404" do
    conn =
      conn(:get, "/does/not/exist")
      |> Pluggy.Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 404
    assert conn.resp_body == "oops"
  end

  test "static files are served from priv/static" do
    conn =
      conn(:get, "/pluggy.css")
      |> Pluggy.Router.call(@opts)

    # Plug.Static uses send_file, which the test adapter reports as :file
    assert conn.state == :file
    assert conn.status == 200
    assert get_resp_header(conn, "content-type") |> hd() =~ "text/css"
  end
end
