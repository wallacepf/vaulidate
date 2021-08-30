#/bin/bash

vault secrets enable -path=secret kv-v2

vault kv put secret/vaulidate/mysecret username="user" password="123abc"

vault policy write goprintenv - <<EOF
path "secret/data/vaulidate/mysecret" {
    capabilities=["read"]
}
EOF

vault auth enable approle

vault write auth/approle/role/vaulidate \
    secret_id_ttl=10m \
    token_num_uses=10 \
    token_ttl=20m \
    token_max_ttl=30m \
    secret_id_num_uses=40
    token_policies=vaulidate

vault read auth/approle/role/vaulidate/role-id
vault write -f auth/approle/role/vaulidate/secret-id