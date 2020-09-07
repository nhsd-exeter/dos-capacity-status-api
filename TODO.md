# TODO

## Priority list

- API ORM Migration
- Documentation
  - Generate API Documentation automatically (CSAPI-9)
- Testing
  - Implement smoke test suite

## Other tasks

- Security
  - Use the library Docker NGINX image for proxy and make sure it is in the latest version
- Infrastructure
  - Split DB responsibility, DoS DB should run a container and API connects to it's own RDS
  - Move RDS Terraform variables to Make profile
  - Sort out tags
  - Create [custom option group](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_WorkingWithOptionGroups.html) for the RDS instance
  - Review Subnet Group
  - Review Security Group rule
  - Refactor RDS configuration
  - Refactor ALB and WAF configuration
  - Refactor Kubernetes deployment scripts
  - Create Route 53 record automatically (CSAPI-55)
  - Create Secrets Manager entry automatically
  - Database backup and restore scripts
- Testing
  - Provide acceptance test suite
  - Provide load test suite
  - Provide security test suite
- Deployment
  - Deploy to production (CSAPI-65, CSAPI-66)
  - Tagging upon deployment (CSAPI-65, CSAPI-66)
- Amend Pipelines

  - Commit Pipeline - Create a Git User for Jenkins so that it can Tag the Git Commits at the end of the pipeline (Card 150)
  - Deploy Pipeline - Add Assurance and load testing when they have been written (Card 145)

- API ORM Migration
  The ORM migration strategy is to have a step in the deployment pipeline that runs a make target
  which in turn runs the Django migration tool. The migration tool will then act on any migration
  files made but not applied to the database in the environment being deployed. This migration may
  also be done through a separate pipeline (still need to be determined if that pipeline is needed).
  (See `Capacity Status API ORM Migration Strategy.draw.io` for more info)

  - Create `apply_migrations` make target
  - Add `apply_migration` make target to pipeline
  - Add 'Check if migration step is needed' step to pipeline
  - Add choice between removing and not removing old models
  - Create make target for destroying old models
  - Add make target for destroying old models to deploy pipeline

- Monitoring:
  - Configure Splunk (CSAPI-70)
  - Configure CloudWatch
- Development
  - Externalise `flake8` and `black` configuration
  - Consider renaming our development DoS DB to pathwaysdos to match the real version
