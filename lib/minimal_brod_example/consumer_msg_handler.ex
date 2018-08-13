defmodule MinimalBrodExample.ConsumerMsgHandler do
  use GenServer

  def start_link(params, opts \\ []) do
    GenServer.start_link(
      __MODULE__,
      params,
      Keyword.merge([name: __MODULE__], opts)
    )
  end

  def init(_consumer_group, _params) do
    {:ok, []}
  end

  def handle_message(_topic, _partition, msg, state) do
    IO.puts "#{inspect msg}"
    {:ok, state}
  end
end
