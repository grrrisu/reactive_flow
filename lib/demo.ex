defmodule Demo do
  @moduledoc """
  Demo module to test ReactiveFlow system.
  Provides functions to start the system, create sample orders,
  and display reactive system statistics.
  """

  alias ReactiveFlow.{Order, OrderProcessor, Analytics}

  def start_system do
    {:ok, _pid} = ReactiveFlow.Supervisor.start_link([])
    IO.puts("🚀 ReactiveFlow System Started!")
  end

  def create_sample_orders do
    orders = [
      Order.new(1, "Alice", [{"Widget", 25.99}, {"Gadget", 15.50}]),
      Order.new(2, "Bob", [{"Thingamajig", 99.99}]),
      Order.new(3, "Charlie", [{"Doohickey", 5.99}, {"Whatsit", 12.99}])
    ]

    Enum.each(orders, fn order ->
      OrderProcessor.submit_order(order)
      # Small delay between orders
      Process.sleep(50)
    end)
  end

  def show_stats do
    # Wait for processing
    Process.sleep(2000)
    stats = OrderProcessor.get_stats()
    metrics = Analytics.get_metrics()

    IO.puts("\n📈 Final Stats:")
    IO.puts("Orders processed: #{stats.processed}")
    IO.puts("Total revenue: $#{stats.revenue}")
    IO.puts("Alerts: #{length(metrics.alerts)}")
  end

  def run_demo do
    start_system()
    Process.sleep(100)

    IO.puts("\n📝 Submitting orders...")
    create_sample_orders()

    show_stats()
  end
end
