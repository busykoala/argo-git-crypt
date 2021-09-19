# Custome ArgoCD with git-crypt

The setup is based on the help of @yhaenggi and Andrei Kvapils Blogpost on
[itnext.io](https://itnext.io/configure-custom-tooling-in-argo-cd-a4948d95626e).

The idea is to replace the git binary with a script which unlocks git-crypt
secrets on fetch.
