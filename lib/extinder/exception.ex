defmodule ExTinder.Error do
  defexception [:code, :message]
end

defmodule ExTinder.NotFoundError do
  defexception [:code, :message]
end

defmodule ExTinder.MatchNotFoundError do
  defexception [:code, :message]
end

defmodule ExTinder.ProxyError do
  defexception [:message]
end
