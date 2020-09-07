# TODO

## Priority list

- Documentation
  - Generate API Documentation automatically (CSAPI-9)
- Testing
  - Can unit and integration tests be run independently
  - Implement smoke test suite

## Other tasks

- Security
  - Use the library Docker NGINX image for proxy and make sure it is in the latest version
- Application
  - Let's revisit the domain model and consider again the naming of `serviceUid` (just `id`), `serviceName` (just `name`?), `capacityStatus` (just `status`?)
- Infrastructure
  - Split DB responsibility, DoS DB should run a container and API connects to it's own RDS
  - Move RDS Terraform variables to Make profile
  - Sort out tags
  - Create [custom option group](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_WorkingWithOptionGroups.html) for the RDS instance
  - Move RDS password to the `uec-dos-api-capacity-status-$(PROFILE)` secret
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
  - Deploy Pipeline - Add AWS/assurance/load testing when they have been written (Card 145)

- API ORM Migration
  (See `Capacity Status API ORM Migration Strategy.draw.io` for more info)

  - Create `makemigrations` make target
  - Add `makemigration` make target to pipeline
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
