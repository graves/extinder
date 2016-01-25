defmodule ExTinder.DateUtil do
  @moduledoc """
  Container for Date parsing and formatting functions.
  """

  use Timex

  @doc """
  Formats a Timex.Date to ISO 8601.
  """
  def format(time) do
    time |> DateFormat.format("{ISOz}")
  end
end
