defmodule MinimalBrodExample.MixProject do
  use Mix.Project

  def project do
    [
      app: :minimal_brod_example,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      applications: [
        :logger,
        :brod
      ],
      mod: {MinimalBrodExample, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:brod, "~> 3.6.1"}
    ]
  end
end
