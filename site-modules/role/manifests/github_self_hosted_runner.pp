# Designates a node a Github self-hosted runner
class role::github_self_hosted_runner {
  include profile::cem_gha_runner_venv
}
