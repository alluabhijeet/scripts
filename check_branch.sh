resource "null_resource" "check_branch" {
  provisioner "local-exec" {
    command = <<EOT
      # Check if current branch is 'main'
      branch=$(git rev-parse --abbrev-ref HEAD)
      if [ "$branch" != "main" ]; then
          echo "Error: Terraform can only be run from the 'main' branch."
          exit 1
      fi

      # Check for uncommitted changes
      if ! git diff-index --quiet HEAD --; then
          echo "Error: Uncommitted changes detected. Please commit or stash them before running Terraform."
          exit 1
      fi

      # Check if the local main branch is up-to-date with the remote main branch
      git fetch origin main
      local_commit=$(git rev-parse HEAD)
      remote_commit=$(git rev-parse origin/main)

      if [ "$local_commit" != "$remote_commit" ]; then
          echo "Error: Local main branch is not up-to-date with remote main. Please pull the latest changes."
          exit 1
      fi
    EOT
  }
}
