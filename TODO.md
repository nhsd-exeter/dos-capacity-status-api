# TODO

## Priority list

- Application
  - PUT vs. PATCH
- Documentation
  - Generate API Documentation automatically (CSAPI-9)
- Testing
  - Check for unit and integration test completeness (CSAPI-64)
  - Can unit and integration tests be run independently
  - Implement smoke test suite

## Other tasks

- Security
  - API throttling (CSAPI-44)
  - Toggle Django debug mode using environment variable
  - Use the library Docker NGINX image for proxy and make sure it is in the latest version
- Application
  - Let's revisit the domain model and consider again the naming of `serviceUid` (just `id`), `serviceName` (just `name`?), `capacityStatus` (just `status`?)
- Infrastructure
  - Split DB responsibility, DoS DB should run a container and API connects to it's own RDS
  - Change RDS DB identifier, currently it is `uec-dos-api-cs-nonprod-db`
  - Change RDS Security Group, currently it is `uec-dos-api-cs-nonprod-db-sg`
  - Move RDS Terraform variables to Make profile
  - Sort out tags
  - Create [custom option group](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_WorkingWithOptionGroups.html) for the RDS instance
  - Move RDS password to the `uec-dos-api-capacity-status-$(PROFILE)` secret
  - Review Subnet Group
  - Review Security Group rule
  - Refactor RDS configuration
  - Refactor ALB and WAF configuration
  - Refactor Kubernetes deployment scripts
  - Crete Route 53 record automatically (CSAPI-55)
  - Create Secrets Manager entry automatically
  - Database backup and restore scripts
- Testing
  - Provide acceptance test suite
  - Provide load test suite
  - Provide security test suite
- Deployment
  - Deploy to production (CSAPI-65, CSAPI-66)
  - Implement Jenkins pipeline (CSAPI-65, CSAPI-66)
  - Tagging upon deployment (CSAPI-65, CSAPI-66)
- Monitoring:
  - Configure Splunk (CSAPI-70)
  - Configure Instana (CSAPI-69)
  - Configure Pingdom
  - Configure CloudWatch
  - Configure Slack
- Development
  - Externalise `flake8` and `black` configuration
  - Consider renaming our development DoS DB to pathwaysdos to match the real version
