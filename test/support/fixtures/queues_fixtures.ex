defmodule OrcaApi.QueuesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `OrcaApi.Queues` context.
  """

  @doc """
  Generate a queue.
  """
  def queue_fixture(attrs \\ %{}) do
    {:ok, queue} =
      attrs
      |> Enum.into(%{})
      |> OrcaApi.Queues.create_queue()

    queue
  end
end
