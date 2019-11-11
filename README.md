# gcp-terraform
Google Cloud Platform - Terraform modules and templates

This repository contains common modules which can be used to create a network, subnet, instance, managed instance groups, kubernetes cluster etc.

It contains an example dev environment terraform template making use of the modules to create objects on GCP.

A sample tfvars file is provided for reference

## Example to setup an instance on gcp on a custom network and subnetwork
```
cd dev/network
cp terraform.tfvars.example terraform.tfvars
```
Edit terraform.tfvars to add your custom configuration

Initialize, Validate and Plan your configuration
```
terraform init
terraform plan
terraform validate
```

To create the terraform objects
```
terraform apply
```
To destroy the terraform objects
```
terraform destroy
```
