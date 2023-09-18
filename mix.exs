defmodule Tbcd.MixProject do
  use Mix.Project

  @version "0.1.0"
  @url "https://github.com/patchkord/tbcd"

  def project() do
    [
      app: :tbcd,
      version: @version,
      elixir: "~> 1.0",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      description: description(),
      package: package(),
      erlc_options: erlc_options(),
      eunit_opts: eunit_options(),
      preferred_cli_env: [eunit: :test],
      compilers: [:elixir_make] ++ Mix.compilers,
      make_cwd: "c_src",
      deps: deps()
    ]
  end

  def erlc_options do
    [
      {:src_dirs, ['src']},
      :debug_info,
      # :bin_opt_info,
      :warn_bif_clash,
      :warn_export_all,
      :warn_obsolete_guard,
      :warn_unused_import,
      :warn_unused_record,
      :warn_untyped_record,
      :warn_shadow_vars,
      :warn_unused_vars,
      :warn_export_vars,
      :warn_exported_vars,
      :warn_unused_function,
      :warn_deprecated_function,
      :strict_validation
    ]
  end

  defp eunit_options do
    [
      verbose: true,
      start: false
    ]
  end

  def application() do
    []
  end

  def deps do
    [
      {:elixir_make, "~> 0.7", runtime: false},
      {:mix_eunit, git: "https://github.com/dantswain/mix_eunit.git", branch: "master"}
      # {:mix_eunit, "~> 0.3.0"}
    ]
  end

  defp description() do
    "A NIF library for decoding and encoding of Telephony binary-coded decimal (TBCD)"
  end

  defp package do
    [
      files: ~w(src lib priv .formatter.exs mix.exs rebar.conf README* readme* LICENSE* license* CHANGELOG* changelog*),
      maintainers: ["Dmitry Korunov"],
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => @url}
    ]
  end
end
