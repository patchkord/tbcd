defmodule Mix.Tasks.Compile.Tbcd do
  use Mix.Task

  @doc false
  def run(_args) do
    priv? = File.dir?("priv")
    Mix.Project.ensure_structure()
    {result, _errcode} = System.cmd(make_cmd(), ["all", "-s", "-C", "c_src"], stderr_to_stdout: true)
    IO.binwrite(result)

    # IF there was no priv before and now there is one, we assume
    # the user wants to copy it. If priv already existed and was
    # written to it, then it won't be copied if build_embedded is
    # set to true.
    if not priv? and File.dir?("priv") do
      Mix.Project.build_structure()
    end

    {:ok, []}
  end

  # This is called by Elixir when `mix clean` runs
  # and `:tbcd` is in the list of compilers.
  @doc false
  def clean() do
    {result, _errcode} = System.cmd(make_cmd(), ["clean", "-C", "c_src"], stderr_to_stdout: true)
    IO.binwrite(result)
    {:ok, []}
  end

  defp make_cmd() do
    if match?({:freebsd, _}, :os.type) do
      "gmake"
    else
      "make"
    end
  end
end
