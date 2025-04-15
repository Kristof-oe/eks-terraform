#!/bin/bash

# terraform init
# terraform fmt
# terraform validate

# plan=${terraform plan -no-color}

# if [ $plan true ]
# then
#     terraform apply -auto-approve
# elif [$plan false]
# then
#     exit 1
# fi

git add .argo_szakd/ouput/*.yaml

git commit -m "updated argo" || echo "there is not any changes"

git push origin main

echo "Done
