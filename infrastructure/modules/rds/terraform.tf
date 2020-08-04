terraform {
  backend "s3" {
    encrypt = true
    # Other parameters are defined at runtime as
    # they differ dependent on the environment used
  }
}
