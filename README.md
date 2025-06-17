# ReactiveFlow

A demonstration of reactive programming using pure Elixir/OTP primitives. ReactiveFlow shows how to build sophisticated reactive systems without additional libraries, leveraging the actor model and message passing for event-driven architecture.

## What is Reactive Programming?

Reactive programming is a paradigm where systems automatically respond to changes in data or events. Instead of imperatively controlling execution flow, you declare how components should react when conditions change. Think of it like a spreadsheet where changing one cell automatically updates all dependent formulas.

## Why Elixir/OTP?

Elixir's OTP (Open Telecom Platform) is inherently designed for reactive systems:

- **Actor Model**: Each process reacts to messages independently
- **Message Passing**: Event-driven communication between processes  
- **Supervision Trees**: Reactive failure handling and recovery
- **Process Monitoring**: Automatic reaction to process lifecycle events
- **Distributed Computing**: Reactive behavior across nodes

## System Architecture

ReactiveFlow demonstrates a reactive order processing pipeline where each component automatically responds to events from upstream components:

```
Order Submitted → Inventory Check → Payment Processing → Fulfillment → Completion
                                    ↓
                              Analytics & Monitoring
```

### Components

- **OrderProcessor**: Main coordinator that triggers reactive chains
- **InventoryChecker**: Reacts to inventory validation requests
- **PaymentProcessor**: Reacts to payment processing needs
- **Fulfillment**: Reacts to fulfillment requests
- **Analytics**: Reacts to business events for monitoring and alerts

## Key Reactive Patterns Demonstrated

### 1. Event-Driven Flow
Orders trigger cascading reactions through the system without centralized orchestration.

```elixir
# Order submission triggers the reactive chain
def handle_cast({:new_order, order}, state) do
  GenServer.cast(InventoryChecker, {:check_inventory, order})
  {:noreply, state}
end
```

### 2. Asynchronous Reactions
Components use timers to simulate async operations and react to results.

```elixir
# Simulate async inventory check
Process.send_after(self(), {:inventory_result, order, :available}, 100)

# React to the result
def handle_info({:inventory_result, order, :available}, state) do
  GenServer.cast(PaymentProcessor, {:process_payment, updated_order})
  {:noreply, state}
end
```

### 3. State-Based Reactions
Components react differently based on current state conditions.

```elixir
# React to high order volume
if new_state.hourly_orders > 5 do
  IO.puts("🚨 High order volume alert!")
end
```

### 4. Time-Based Reactions
Periodic reactive behavior using process timers.

```elixir
# Reactive analytics reporting every 5 seconds
defp schedule_metrics_check do
  Process.send_after(self(), :check_metrics, 5_000)
end
```

### 5. Failure Recovery
Supervisor trees provide reactive failure handling.

```elixir
# Automatic process restart on failure
Supervisor.init(children, strategy: :one_for_one)
```

## Getting Started

### Prerequisites

- Elixir 1.12+ 
- No additional dependencies required - uses only OTP primitives!

### Running the Demo

```bash
mix deps.get
iex -S mix
```

Then in IEx:

```elixir
ReactiveFlow.Demo.run_demo()
```

### Example Output

```
🚀 ReactiveFlow System Started!

📝 Submitting orders...
📦 Processing order 1 for Alice
🔍 Checking inventory for order 1
📦 Processing order 2 for Bob
🔍 Checking inventory for order 2
✓ Inventory available for order 1
💳 Processing payment for order 1 - $41.49
✓ Inventory available for order 2
💳 Processing payment for order 2 - $99.99
💰 Payment successful for order 1
📋 Fulfilling order 1
💰 Payment successful for order 2
📋 Fulfilling order 2
📦 Order 1 shipped!
✅ Order 1 completed! Revenue: $41.49
📦 Order 2 shipped!
✅ Order 2 completed! Revenue: $99.99
📊 Analytics: 3 orders this period
🚨 High order volume alert! 6 orders processed

📈 Final Stats:
Orders processed: 3
Total revenue: $159.47
Alerts: 1
```

## API Reference

### Starting the System

```elixir
# Start all reactive components
Demo.start_system()
```

### Submitting Orders

```elixir
# Create and submit orders
order = Order.new(1, "Customer", [{"Item", 25.99}])
OrderProcessor.submit_order(order)
```

### Getting Statistics

```elixir
# Get processing statistics
OrderProcessor.get_stats()
# => %{processed: 3, revenue: 159.47}

# Get analytics metrics  
Analytics.get_metrics()
# => %{hourly_orders: 0, alerts: ["High volume: 6 orders"]}
```

## Understanding the Reactive Flow

1. **Order Submission**: `OrderProcessor` receives new order
2. **Inventory Check**: Automatically forwards to `InventoryChecker`
3. **Payment Processing**: Successful inventory check triggers `PaymentProcessor`
4. **Fulfillment**: Successful payment triggers `Fulfillment`
5. **Completion**: Fulfillment completion updates `OrderProcessor` statistics
6. **Analytics**: All events are reactively tracked by `Analytics`

Each step happens automatically based on the previous step's completion - no central coordinator needed!

## Extending ReactiveFlow

### Adding New Reactive Components

1. Create a GenServer that reacts to specific message patterns
2. Add message handlers for reactive behavior
3. Send messages to trigger reactions in other components
4. Add to the supervision tree

Example:
```elixir
defmodule ShippingTracker do
  @moduledoc "Reacts to shipment events"
  use GenServer
  
  def handle_cast({:track_shipment, order}, state) do
    # React to shipment tracking request
    Process.send_after(self(), {:shipment_update, order}, 1000)
    {:noreply, state}
  end
  
  def handle_info({:shipment_update, order}, state) do
    # React to shipment status change
    GenServer.cast(CustomerNotifications, {:notify_shipment, order})
    {:noreply, state}
  end
end
```

### Adding Reactive Rules

Enhance existing components with new reactive patterns:

```elixir
# React to failed payments
def handle_info({:payment_result, order, :failed}, state) do
  GenServer.cast(CustomerService, {:payment_failed, order})
  {:noreply, state}
end

# React to inventory shortages
def handle_info({:inventory_result, order, :out_of_stock}, state) do
  GenServer.cast(SupplierNotifications, {:restock_needed, order})
  {:noreply, state}
end
```

## Benefits of This Approach

- **Scalability**: Each component is an independent process
- **Fault Tolerance**: Process isolation and supervision
- **Maintainability**: Clear reactive relationships between components
- **Testability**: Each component can be tested in isolation
- **Distributed**: Easily scales across multiple nodes
- **No Dependencies**: Uses only Elixir/OTP primitives

## Learn More

- [OTP Design Principles](https://erlang.org/doc/design_principles/users_guide.html)
- [GenServer Documentation](https://hexdocs.pm/elixir/GenServer.html)
- [Supervisor Documentation](https://hexdocs.pm/elixir/Supervisor.html)
- [Process Documentation](https://hexdocs.pm/elixir/Process.html)

## License

MIT License - Feel free to use this as a learning resource or starting point for your own reactive systems!