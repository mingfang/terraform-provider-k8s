# Developing terraform-provider-k8s

How to develop or make contributions to this project.

1. Make sure to copy file `kubeconfig` to the current directory
2. Run `./dev`.  This will run a container with the source and all the necessary development tools including Terraform, golang, and glide.
3. Run `glide up` to update vendored packages.  This may take a while.
4. Run `./make` to make the plugin binary.  Run this whenever the code changes.

That's it!  You're all set.