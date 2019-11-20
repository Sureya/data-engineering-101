#!/usr/bin/env bash

values=$(cd section-3/terraform-scripts/ ; cat terraform.tfstate  | jq '.outputs')
file="vars.env"

rm -rf ${file}
touch ${file}

for s in $(echo $values | jq -r "to_entries|map(\"\(.key)=\(.value.value|tostring)\")|.[]" ); do
    echo "export ${s}" >> ${file}
done

tr -d ''| cat ${file}