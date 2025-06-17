defmodule ReactiveFlow.PaymentProcessor do
  @moduledoc """
  Reacts to payment processing requests. Handles async payment processing
  and reactively forwards successful payments to fulfillment.
  """
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(state) do
    {:ok, state}
  end

  def handle_cast({:process_payment, order}, state) do
    IO.puts("💳 Processing payment for order #{order.id} - $#{order.total}")

    # Simulate payment processing
    Process.send_after(self(), {:payment_result, order, :success}, 200)

    {:noreply, state}
  end

  def handle_info({:payment_result, order, :success}, state) do
    IO.puts("💰 Payment successful for order #{order.id}")

    # React by sending to fulfillment
    updated_order = %{order | status: :paid}
    GenServer.cast(Fulfillment, {:fulfill_order, updated_order})

    {:noreply, state}
  end
end
