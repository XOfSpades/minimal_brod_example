defmodule MinimalBrodExample.ConsumerSupervisor do
  alias MinimalBrodExample.GroupSubscriberConfig

  @behaviour :supervisor3

  @brod_client :brod_kafka_base_server
  @consumer_group "foo"

  @default_subscriper_config %GroupSubscriberConfig{
    client: @brod_client,
    consumer_group: @consumer_group,
    group_config: [],
    consumer_config: [],
    callback_module: MinimalBrodExample.ConsumerMsgHandler,
    call_back_init_args: []
  }

  def start_link(params) do
    :supervisor3.start_link({:local, __MODULE__}, __MODULE__, params)
  end

  def init(options) do
    topics = Keyword.get(options, :topics)

    subscriber_config =
      @default_subscriper_config
      |> Map.put(:topics, topics)
      |> GroupSubscriberConfig.to_arg_list()

    children =
      [
        child_spec(:brod_group_subscriber, subscriber_config)
      ]
    {:ok, {{:one_for_one, 0, 1}, children}}
  end

  def post_init(_) do
    :ignore
  end

  defp child_spec(mod, start_args) do
    {mod,
     {mod, :start_link, start_args},
     {:permanent, 30},
     5000,
     :worker,
     [mod]}
  end
end
