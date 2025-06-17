defmodule ReactiveFlow.MixProject do
  use Mix.Project

  def project do
    [
      app: :reactive_flow,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    []
  end

  defp description() do
    "A demonstration of reactive programming using pure Elixir/OTP primitives"
  end

  defp package() do
    [
      name: "reactive_flow",
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/grrrisu/reactive_flow"}
    ]
  end
end
