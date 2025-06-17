defmodule ReactiveFlow.Fulfillment do
  @moduledoc """
  Reacts to fulfillment requests. Handles order shipping simulation
  and reactively completes the order processing cycle.
  """
  use GenServer

  alias ReactiveFlow.OrderProcessor

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(state) do
    {:ok, state}
  end

  def handle_cast({:fulfill_order, order}, state) do
    IO.puts("📋 Fulfilling order #{order.id}")

    # Simulate fulfillment
    Process.send_after(self(), {:fulfillment_complete, order}, 150)

    {:noreply, state}
  end

  def handle_info({:fulfillment_complete, order}, state) do
    IO.puts("📦 Order #{order.id} shipped!")

    # React by completing the order
    completed_order = %{order | status: :completed}
    GenServer.cast(OrderProcessor, {:order_completed, completed_order})

    {:noreply, state}
  end
end
