defmodule ChaosSpawn.ProcessWatcher do
  use GenServer
  require Logger

  ## Client API
  def all_pids(process_watcher) do
    GenServer.call(process_watcher, {:all_pids})
  end

  def get_random_pid(process_watcher) do
    GenServer.call(process_watcher, {:get_random_pid})
  end

  def add_pid(process_watcher, pid) do
    GenServer.cast(process_watcher, {:new_pid, pid})
  end

  #######  Server API
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    {:ok, []}
  end

  def handle_call({:all_pids}, _from, pids) do
    {:reply, pids, pids}
  end

  def handle_call({:get_random_pid}, _from, pids) do
    updated_pids = pids
      |> only_alive_pids
    pid = pick_random_pid(updated_pids)
    {:reply, pid, updated_pids}
  end

  def handle_cast({:new_pid, pid}, pids) when is_pid(pid) do
    updated_pids = case Process.alive?(pid) do
      true  -> [pid | pids]
      false -> pids
    end
    {:noreply, updated_pids}
  end

  def handle_cast({:new_pid, _invalid_pid}, pids) do
    Logger.warn "Invalid PID recieved"
    {:noreply, pids}
  end

  ####### Utilities
  defp only_alive_pids(pids) do
    pids
      |> Enum.filter(&Process.alive?/1)
  end

  defp pick_random_pid(pids) do
    pids
      |> Enum.shuffle
    case Enum.count(pids) do
      0 ->
        :none
      _ ->
        [pid] = pids |> Enum.take(1)
        pid
    end
  end

end
