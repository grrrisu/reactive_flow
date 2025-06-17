defmodule ReactiveFlow.Analytics do
  @moduledoc """
  Reacts to business events for analytics and monitoring.
  Tracks order metrics, generates alerts based on thresholds,
  and provides reactive time-based reporting.
  """
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, %{hourly_orders: 0, alerts: []}, name: __MODULE__)
  end

  def get_metrics do
    GenServer.call(__MODULE__, :get_metrics)
  end

  def init(state) do
    # Reactive timer - check metrics every 5 seconds
    schedule_metrics_check()
    {:ok, state}
  end

  def handle_cast({:order_completed, order, processor_state}, state) do
    new_state = %{state | hourly_orders: state.hourly_orders + 1}

    # React to high order volume
    if new_state.hourly_orders > 5 do
      IO.puts("🚨 High order volume alert! #{new_state.hourly_orders} orders processed")
      alert = "High volume: #{new_state.hourly_orders} orders"
      new_state = %{new_state | alerts: [alert | state.alerts]}
    end

    {:noreply, new_state}
  end

  def handle_info(:check_metrics, state) do
    if state.hourly_orders > 0 do
      IO.puts("📊 Analytics: #{state.hourly_orders} orders this period")
    end

    # Reset counters and schedule next check
    schedule_metrics_check()
    {:noreply, %{state | hourly_orders: 0}}
  end

  def handle_call(:get_metrics, _from, state) do
    {:reply, state, state}
  end

  defp schedule_metrics_check do
    Process.send_after(self(), :check_metrics, 5_000)
  end
end
