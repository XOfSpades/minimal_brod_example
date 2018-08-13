defmodule MinimalBrodExample.GroupSubscriberConfig do
  defstruct client: nil,
            consumer_group: nil,
            topics: [],
            group_config: nil,
            consumer_config: nil,
            callback_module: nil,
            call_back_init_args: nil

  def to_arg_list(%__MODULE__{} = config) do
    [
      config.client,
      config.consumer_group,
      config.topics,
      config.group_config,
      config.consumer_config,
      config.callback_module,
      config.call_back_init_args
    ]
  end
end
