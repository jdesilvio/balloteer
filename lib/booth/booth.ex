defmodule Balloteer.Booth do

  @doc """
  Starts a voting booth with the given `task_id`.
  The task ID will be used to route votes 
  to the correct voting booth.
  """
  def start_link(task_id) do
    Agent.start_link(fn -> [] end, name: task_id)
  end

  @doc """
  Get all data for received votes.
  """
  def get(booth) do
    Agent.get(booth, fn list -> list end)
  end

  @doc """
  Count `vote` by updating stored data. 
  """
  def update(booth, vote) do
    Agent.update(booth, fn list -> [vote|list] end)
  end

  @doc """
  The number of votes cast.
  Returns the length of the list of votes.
  """
  def count_votes(booth) do
    length(Balloteer.Booth.get(booth)) 
  end

  @doc """
  Get vote values for received votes.
  Returns a list of votes.
  """
  def get_votes(booth) do
    votes(Balloteer.Booth.get(booth), [])
  end

  defp votes([head|tail], list) do
    {h, t, _} = {head, tail, list}
    votes(t, [h[:vote]|list])
  end

  defp votes([], list) do
    list
  end

  @doc """
  Tally the votes that have been received.

  Returns a tally of the votes in a map %{}.
  """
  def tally(booth) do
    count(Balloteer.Booth.get_votes(booth))
  end

  defp count(votes) when is_list(votes) do
    Enum.reduce(votes, %{}, &update_count/2)
  end

  defp update_count(vote, acc) do
    Map.update acc, String.to_atom(vote), 1, &(&1 + 1)
  end
end

