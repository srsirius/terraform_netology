terraform {
    backend "s3" {
        profile                 = "sirius-netology"
        bucket                  = "sirius-bucket"
        dynamodb_table          = "app-state"
        region                  = "us-east-1"
        key                     = "app-state/terraform.tfstate"
        }
}
