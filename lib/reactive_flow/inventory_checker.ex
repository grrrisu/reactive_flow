defmodule ReactiveFlow.InventoryChecker do
  @moduledoc """
  Reacts to inventory check requests. Simulates async inventory validation
  and reactively forwards successful checks to payment processing.
  """
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(state) do
    {:ok, state}
  end

  def handle_cast({:check_inventory, order}, state) do
    IO.puts("🔍 Checking inventory for order #{order.id}")

    # Simulate inventory check with random delay
    Process.send_after(self(), {:inventory_result, order, :available}, 100)

    {:noreply, state}
  end
end
