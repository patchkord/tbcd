defmodule Mix.Tasks.Compile.Tbcd do
  use Mix.Task

  @doc false
  def run(_args) do
    {result, _errcode} = System.cmd(make_cmd(), ["-s", "-C", "c_src"], stderr_to_stdout: true)
    IO.binwrite(result)
    :ok
  end

  # This is called by Elixir when `mix clean` runs
  # and `:tbcd` is in the list of compilers.
  @doc false
  def clean() do
    {result, _errcode} = System.cmd(make_cmd(), ["clean","-C", "c_src"], stderr_to_stdout: true)
    IO.binwrite(result)
    :ok
  end

  defp make_cmd() do
    if match?({:freebsd, _}, :os.type) do
      "gmake"
    else
      "make"
    end
  end
end
