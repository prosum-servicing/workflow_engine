defmodule WorkflowEngine.MixProject do
  use Mix.Project

  def project do
    [
      app: :workflow_engine,
      version: "1.1.1",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      preferred_cli_env: ["test.ci": :test],
      aliases: aliases(),
      cli: cli()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ok, "~> 2.3"},
      {:jason, "~> 1.2"},
      {:ex_minimatch, github: "box-id/ex_minimatch", ref: "ee65d07"},
      # Our fork of JsonLogic is used at runtime and during tests, but in production it has to be
      # provided by upstream application to avoid version conflicts
      {:json_logic, github: "box-id/json_logic_elixir", tag: "1.0.0", only: [:dev, :test]},
      # Same for BXDK. We could use `optional: true`, but since git tags are exact, this is not
      # a suitable way of expressing a "minimum version" requirement.
      {:bxdk, github: "box-id/bxdk", tag: "0.30.0", only: [:dev, :test]},
      {:mix_test_watch, "~> 1.0", only: :dev, runtime: false},
      {:mox, "~> 1.0", only: :test},
      {:bypass, "~> 2.1", only: :test},
      {:config_helpers, "~> 1.0"},
      {:nimble_csv, "~> 1.2.0"},
      {:stream_split, "~> 0.1.7"},
      {:req, System.get_env("BX_CI_REQ_VERSION", "~> 0.3.1 or ~> 0.5.0")}
    ]
  end

  def cli do
    [preferred_envs: ["test.including_external": :test]]
  end

  defp aliases do
    [
      "test.including_external": ["test --include external_service"],
      "test.ci": ["test --color --exclude external:true"]
    ]
  end
end
