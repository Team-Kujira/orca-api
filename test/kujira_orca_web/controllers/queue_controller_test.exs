defmodule KujiraOrcaWeb.QueueControllerTest do
  use KujiraOrcaWeb.ConnCase

  import KujiraOrca.QueuesFixtures

  alias KujiraOrca.Queues.Queue

  @create_attrs %{

  }
  @update_attrs %{

  }
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all queues", %{conn: conn} do
      conn = get(conn, Routes.queue_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create queue" do
    test "renders queue when data is valid", %{conn: conn} do
      conn = post(conn, Routes.queue_path(conn, :create), queue: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.queue_path(conn, :show, id))

      assert %{
               "id" => ^id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.queue_path(conn, :create), queue: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update queue" do
    setup [:create_queue]

    test "renders queue when data is valid", %{conn: conn, queue: %Queue{id: id} = queue} do
      conn = put(conn, Routes.queue_path(conn, :update, queue), queue: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.queue_path(conn, :show, id))

      assert %{
               "id" => ^id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, queue: queue} do
      conn = put(conn, Routes.queue_path(conn, :update, queue), queue: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete queue" do
    setup [:create_queue]

    test "deletes chosen queue", %{conn: conn, queue: queue} do
      conn = delete(conn, Routes.queue_path(conn, :delete, queue))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.queue_path(conn, :show, queue))
      end
    end
  end

  defp create_queue(_) do
    queue = queue_fixture()
    %{queue: queue}
  end
end
