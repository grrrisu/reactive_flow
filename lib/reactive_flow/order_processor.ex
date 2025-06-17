defmodule ReactiveFlow.OrderProcessor do
  @moduledoc """
  Main order processor that reacts to incoming orders and coordinates the flow.
  Maintains statistics and triggers the reactive chain when orders are submitted.
  """
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  # Public API
  def submit_order(order) do
    GenServer.cast(__MODULE__, {:new_order, order})
  end

  def get_stats do
    GenServer.call(__MODULE__, :get_stats)
  end

  # GenServer callbacks
  def init([]) do
    {:ok, %{processed: 0, revenue: 0}}
  end

  def handle_cast({:new_order, order}, state) do
    IO.puts("📦 Processing order #{order.id} for #{order.customer}")

    # React by sending order to inventory checker
    GenServer.cast(InventoryChecker, {:check_inventory, order})

    {:noreply, state}
  end

  def handle_cast({:order_completed, order}, state) do
    IO.puts("✅ Order #{order.id} completed! Revenue: $#{order.total}")

    new_state = %{
      processed: state.processed + 1,
      revenue: state.revenue + order.total
    }

    # Reactively notify analytics
    GenServer.cast(Analytics, {:order_completed, order, new_state})

    {:noreply, new_state}
  end

  def handle_call(:get_stats, _from, state) do
    {:reply, state, state}
  end
end
