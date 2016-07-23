defmodule Balloteer do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Balloteer.Booth, [])
    ]

    opts = [strategy: :simple_one_for_one, name: Balloteer.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @doc """
  Create a supervised voting booth for a given `task_id`.
  """
  def create_booth(task_id) do
    Supervisor.start_child(Balloteer.Supervisor, [task_id])
  end

  @doc """
  Return a list of all PIDs under the Supervisor
  """
  def get_pids() do
    pop_pid(Supervisor.which_children(Balloteer.Supervisor), [])
  end

  defp pop_pid([head|tail], list) do
    {_, pid, _, _} = head
    pop_pid(tail, [pid|list])
  end

  defp pop_pid([], list) do
    list
  end
end

