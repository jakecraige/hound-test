defmodule App.Api.V1.TokenControllerTest do
  use App.ConnCase

  alias App.StubFacebook

  require App.StubFacebook

  test "with a valid facebook_token it returns an auth token" do
    conn = build_conn()
    user = insert(:user)
    params = %{"facebook_token" => user.facebook_token}
    StubFacebook.me(user.facebook_token, 200, %{"id" => user.facebook_id})

    conn = post(conn, api_v1_token_path(conn, :create, params))

    assert %{"authorization" => token} = json_response(conn, 200)
    assert Phoenix.Token.verify(App.Endpoint, "user", token) ==
      {:ok, user.id}
  end

  test "with an invalid facebook_token it responds with an error" do
    conn = build_conn()
    params = %{"facebook_token" => "invalid_token"}
    StubFacebook.me("invalid_token", 400, %{"error" => %{}})

    conn = post(conn, api_v1_token_path(conn, :create, params))

    assert %{"error" => "Invalid token"} = json_response(conn, 200)
  end
end
