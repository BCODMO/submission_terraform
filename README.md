# laminar_terraform
Terraform scripts for submission architecture

To update the ECR docker containers, see the deploy.sh scripts in bcodmo_submission repo 

Use `terraform workspace select production` to deploy to production

You will need to manually create the state bucket and dynamoDB table. See backend.tf file for information about those resources. After that you'll need to import those resources like:

```
terraform import aws_dynamodb_table.terraform_locks submission-terraform-locks;
terraform import aws_s3_bucket.terraform_state bcodmo-submission-terraform-state;
```

You will need to import the https certificate. For example:

```
terraform import aws_acm_certificate.cert arn:aws:acm:us-east-1:504672911985:certificate/7d76e817-d2dc-44e6-902c-d9cb8898e6f2
```
