
## Before you deploy anything

We'll use one namespace and one service account per use case and to create all these objects check below

```bash
kubectl apply -f ./deployments/ns.yaml
kubectl apply -f ./deployments/sa.yaml
```

# Install Vault using the helm chart 

Add hashicorp repo to helm

```bash
helm repo add hashicorp https://helm.releases.hashicorp.com
```

Install vault in a namespace called vault

```bash
helm install vault hashicorp/vault -f ./vault-configs/vault-cluster-config.yml -n vault
```

This will create a vault instance in Dev Mode (NOT RECOMMENDED FOR PRODUCTION)

After that, you can explore the Vault config example in `vault-configs` directory

Exec into Vault's shell to create your config

```bash
kubectl exec -it -n vault vault-0 -- /bin/sh
```

## Approle auth method for native use case

Get your role-id and secret-id from Vault to pass it as Env vars

```bash
vault read auth/approle/role/<your role>/role-id
vault write -f auth/approle/role/<your role>/secret-id
```

Set the Role ID and Secret ID in `deployments/native.yaml`.
