# Custome ArgoCD with git-crypt

The setup is based on the help of @yhaenggi and Andrei Kvapils Blogpost on
[itnext.io](https://itnext.io/configure-custom-tooling-in-argo-cd-a4948d95626e).

The idea is to replace the git binary with a script which unlocks git-crypt
secrets on fetch.

## How to Setup

Deploy the custom ArgoCD image (`busykoala/argo-git-crypt:vX.X.X`).

```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
# use this custom image with the binary replacement
kubectl -n argocd set image deploy/argocd-repo-server argocd-repo-server=docker.io/busykoala/argo-git-crypt:v2.1.2
```

Generate and add gpg-key-secret.
(Checkout [this repo](https://github.com/busykoala/argo-git-crypt.git))

```bash
git clone https://github.com/busykoala/k8s-gpg-secret.git
cd k8s-gpg-secret
./generate-secret.sh

# put secret output into gpg-secret.yml and run
kubectl apply -f gpg-secret.yml
```

Patch the secret into the `argocd-repo-server`. Argo CD automatically loads
gpg keys from this directory during the startup, so it loads our private key
as well.

```bash
kubectl patch deployment argocd-repo-server -p "$(cat argocd-gpg-key-patch.yml)" -n argocd
```

Check if key was correctly configured:

```bash
kubectl exec -ti deploy/argocd-repo-server -n argocd -- bash
GNUPGHOME=/app/config/gpg/keys gpg --list-secret-keys
```
