defmodule ReactiveFlow.Supervisor do
  @moduledoc """
  Main supervisor for the ReactiveFlow system.
  Manages all reactive components with one-for-one restart strategy,
  providing reactive failure recovery.
  """
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    children = [
      OrderProcessor,
      InventoryChecker,
      PaymentProcessor,
      Fulfillment,
      Analytics
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
