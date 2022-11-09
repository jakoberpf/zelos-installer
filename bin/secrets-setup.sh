#!/usr/bin/env bash
GIT_ROOT=$(git rev-parse --show-toplevel)
cd $GIT_ROOT

# Setup OCI credentials ...
mkdir -p .oci
mkdir -p .oci/keys
rm -f .oci/config
touch .oci/config

# ... for kubernetes
oci_credentials=$(yq e -o=j -I=0 ".oci" terraform/terragrunt.yaml)
oci_user=$(echo "${oci_credentials}" | yq '.user_ocid')
oci_fingerprint=$(echo "${oci_credentials}" | yq '.fingerprint')
oci_tenancy=$(echo "${oci_credentials}" | yq '.tenancy_ocid')
oci_region=$(echo "${oci_credentials}" | yq '.region')
printf "[KUBERNETES]\nuser=${oci_user}\nfingerprint=${oci_fingerprint}\ntenancy=${oci_tenancy}\nregion=${oci_region}\nkey_file=${PWD}/.oci/keys/kubernetes.pem\n\n" >> .oci/config
echo -e $(echo "${oci_credentials}" | yq '.private_key') > .oci/keys/kubernetes.pem
oci setup repair-file-permissions --file .oci/config
oci setup repair-file-permissions --file .oci/keys/kubernetes.pem

# Download config from bucket
oci_credentials=$(yq e -o=j -I=0 ".oci" terraform/terragrunt.yaml)
oci_compartment_ocid=$(echo "${oci_credentials}" | yq '.compartment_ocid')
oci_namespace=$(oci os ns get --profile=KUBERNETES | jq '.data' | xargs)
oci_bucket=$(oci os bucket list --profile=KUBERNETES --compartment-id="$oci_compartment_ocid" | jq '.data[] | select(.name=="zelos")')
oci os object get --profile=KUBERNETES -ns "$oci_namespace" -bn zelos --name kubespray/admin.live.conf --file .kube/admin.live.conf
