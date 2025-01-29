# AWS AppConfig Configuration Management with GitLab CI/CD

This repository demonstrates an automated approach to managing and deploying application configurations using AWS AppConfig integrated with GitLab CI/CD pipeline.

## Overview

This solution provides a structured approach to managing configurations across multiple environments and tenants using AWS AppConfig, addressing the challenges of:
- Multi-tenant configuration management
- Environment-specific settings
- Version control and tracking
- Automated deployment and rollback capabilities

## Folder Structure

```
├── template
│   ├── AllowList.yml
│   ├── FeatureFlags.yml
│   └── ThrottlingLimits.yml
└── tenants
    ├── tenant1
    │   ├── dev
    │   │   ├── AllowList.yml
    │   │   ├── FeatureFlags.yml
    │   │   └── ThrottlingLimits.yml
    │   └── qa
    │       ├── AllowList.yml
    │       ├── FeatureFlags.yml
    │       └── ThrottlingLimits.yml
    └── tenant2
        ├── dev
        │   ├── AllowList.yml
        │   ├── FeatureFlags.yml
        │   └── ThrottlingLimits.yml
        └── qa
            ├── AllowList.yml
            ├── FeatureFlags.yml

```


### Structure Overview
- `template/`: Base configuration templates
- `tenants/`: Tenant-specific configurations
  - Each tenant has `dev` and `qa` environments
  - Environment-specific configurations override templates

## Features

- **Standardized Templates**: Base configurations for consistency
- **Tenant Customization**: Override capabilities per tenant
- **Environment Isolation**: Separate dev and qa configurations
- **Version Control**: Full tracking of configuration changes
- **Automated Deployment**: Intelligent deployment based on changes

## Pipeline Stages


### 1. Update-App-Config
- Creates/updates AWS AppConfig applications per tenant
- Manages configuration profiles (AllowList, FeatureFlags, ThrottlingLimits)
- Creates new configuration versions

### 2. Deploy-App-Config
- Manages deployments across environments
- Handles tenant-specific configurations
- Monitors deployment status and handles rollbacks

## Prerequisites

1. AWS Account with appropriate permissions
2. GitLab CI/CD configured with AWS credentials
3. GitLab Runner setup
4. AWS AppConfig service access

## Configuration Example

```yaml
# template/ThrottlingLimits.yml example
# Base configuration for API throttling and rate limiting

api_limit:
  global:
    requests_per_second: 100
    concurrent_requests: 50
    max_retry_attempts: 3

service_specific:
  user_service:
      requests_per_second: 80
      burst_limit: 100
  
  payment_service:
    transactions:
      requests_per_second: 30
      burst_limit: 40
      cooling_period_seconds: 60

batch_operations:
  max_batch_size: 1000
  concurrent_batches: 5
  timeout_seconds: 30

# When deploying one can override these defaults

```

## Pipeline Configuration

See .gitlab-ci.yml for complete pipeline configuration.

## Cleanup

Use delete_appconfig_resources.sh to clean up AWS AppConfig resources:

chmod +x delete_appconfig_resources.sh
./delete_appconfig_resources.sh


Warning: This script deletes ALL AppConfig resources in the configured AWS account and region.

## Security

See [CONTRIBUTING](CONTRIBUTING.md#security-issue-notifications) for more information.

## License

This library is licensed under the MIT-0 License. See the LICENSE file.
