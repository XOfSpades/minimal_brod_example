defmodule MinimalBrodExample do
  require Logger

  @brod_client :brod_kafka_base_server

  @topic "test_topic"
  @consumer_group "foobar"

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    Logger.info("Start minimal brod example")

    brod_client_config = [
      {:allow_topic_auto_creation, false},
      {:auto_start_producers, true},
      {:restart_delay_seconds, 1}
    ]

    kafka_endpoints = [{'localhost', 38222}]

    # Start basic brod client
    :ok =
      :brod.start_client(
        kafka_endpoints,
        @brod_client,
        brod_client_config
      )

    consumer_config = [{:begin_offset, :earliest}]

    # Define workers and child supervisors to be supervised
    children = [
      supervisor(
        MinimalBrodExample.ConsumerSupervisor,
        [[topics: [@topic], consumer_group: @consumer_group]]
      )
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [
      strategy: :one_for_one,
      restart: :permanent,
      name: MinimalBrodExample.Supervisor
    ]

    Supervisor.start_link(children, opts)
  end
end
