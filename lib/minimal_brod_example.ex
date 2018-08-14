defmodule MinimalBrodExample do
  require Logger

  @brod_client :brod_kafka_base_server

  @topic "test_topic"
  @consumer_group "foobar"

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    Logger.info("Start minimal brod example")

    brod_client_config = [
      {:allow_topic_auto_creation, true},
      {:auto_start_producers, true},
      {:restart_delay_seconds, 1}
    ]

    kafka_endpoints = [{'test-kafka-s', 38222}]

    # Start basic brod client
    spawn(fn ->
      :brod.start_client(
        kafka_endpoints,
        @brod_client,
        brod_client_config
      )
    end)

    spawn(
      fn ->
        :timer.sleep(10000)

        {:ok, pid} = :brod.get_producer(@brod_client, @topic, 0)

        :brod.produce(pid, "msg1", %{ts: 1534250000000, key: "meta_key", value: "testtesttest"}) |> IO.inspect

        IO.inspect "Produce message:"
        :brod.produce(@brod_client, @topic, 0, "msg3", "my last message")
        IO.puts "Produced"
      end
    )

    consumer_config = [{:begin_offset, :earliest}]

    # Define workers and child supervisors to be supervised
    children = [
      supervisor(
        MinimalBrodExample.Consumer.Supervisor,
        [
          [
            topics: [@topic],
            consumer_group: @consumer_group,
            client: @brod_client
          ]
        ]
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
