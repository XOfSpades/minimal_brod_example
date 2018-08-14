defmodule MinimalBrodExample.Consumer.Supervisor do
  alias MinimalBrodExample.Consumer.GroupSubscriberConfig

  @behaviour :supervisor3

  @default_subscriper_config %GroupSubscriberConfig{
    client: nil,
    consumer_group: nil,
    topics: [],
    group_config: [],
    consumer_config: [],
    callback_module: MinimalBrodExample.Consumer.MsgHandler,
    call_back_init_args: []
  }

  def start_link(params) do
    :supervisor3.start_link({:local, __MODULE__}, __MODULE__, params)
  end

  def init(options) do
    args = %{
      topics: Keyword.get(options, :topics),
      consumer_group: Keyword.get(options, :consumer_group),
      client: Keyword.get(options, :client)}

    subscriber_config =
      @default_subscriper_config
      |> Map.merge(args)
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
