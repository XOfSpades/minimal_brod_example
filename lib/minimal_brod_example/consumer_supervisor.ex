defmodule MinimalBrodExample.ConsumerSupervisor do
  alias MinimalBrodExample.GroupSubscriberConfig

  @behaviour :supervisor3

  @default_subscriper_config %GroupSubscriberConfig{
    client: @brod_client,
    consumer_group: nil,
    topics: [],
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
    consumer_group = Keyword.get(options, :consumer_group)

    subscriber_config =
      @default_subscriper_config
      |> Map.merge(%{topics: topics, consumer_group: consumer_group})
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
