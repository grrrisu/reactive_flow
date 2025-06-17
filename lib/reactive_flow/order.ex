defmodule ReactiveFlow.Order do
  @moduledoc """
  Order struct representing a customer order with items and status tracking.
  """
  defstruct [:id, :customer, :items, :status, :total, :created_at]

  def new(id, customer, items) do
    %__MODULE__{
      id: id,
      customer: customer,
      items: items,
      status: :pending,
      total: Enum.reduce(items, 0, fn {_item, price}, acc -> acc + price end),
      created_at: DateTime.utc_now()
    }
  end
end
