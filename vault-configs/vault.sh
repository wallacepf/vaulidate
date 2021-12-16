#/bin/bash

vault secrets enable -path=secret kv-v2

vault kv put secret/vaulidate/mysecret username="user" password="comingfromvault"

vault policy write vaulidate-policy - <<EOF
path "secret/data/vaulidate/mysecret" {
    capabilities=["read"]
}
EOF

vault auth enable kubernetes

vault write auth/kubernetes/config \
        kubernetes_host="https://$KUBERNETES_PORT_443_TCP_ADDR:443" \
        token_reviewer_jwt="$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" \
        kubernetes_ca_cert=@/var/run/secrets/kubernetes.io/serviceaccount/ca.crt \
        issuer="https://kubernetes.default.svc.cluster.local" \
        disable_iss_validation=true

vault write auth/kubernetes/role/vaulidate-env \
        bound_service_account_names=vaulidate-env \
        bound_service_account_namespaces=vaulidate-env \
        policies=vaulidate-policy \
        ttl=24h

vault write auth/kubernetes/role/vaulidate-file \
        bound_service_account_names=vaulidate-file \
        bound_service_account_namespaces=vaulidate-file \
        policies=vaulidate-policy \
        ttl=24h

# vault write auth/kubernetes/role/vaulidate-native \
#         bound_service_account_names=vaulidate-native \
#         bound_service_account_namespaces=vaulidate-native \
#         policies=vaulidate-policy \
#         ttl=24h

vault auth enable approle

vault write auth/approle/role/vaulidate-native \
    secret_id_ttl=30m \
    token_num_uses=10 \
    token_ttl=30m \
    token_max_ttl=60m \
    secret_id_num_uses=40 \
    token_policies=vaulidate-policy

vault read auth/approle/role/vaulidate/role-id
vault write -f auth/approle/role/vaulidate/secret-id