#!/bin/bash

# List all applications
APPS=$(aws appconfig list-applications --query 'Items[*].Id' --output text)

for APP_ID in $APPS
do
  echo "Processing application $APP_ID"
  
  # List and delete all environments for this application
  ENVS=$(aws appconfig list-environments --application-id $APP_ID --query 'Items[*].Id' --output text)
  for ENV_ID in $ENVS
  do
    echo "  Deleting environment $ENV_ID"
    aws appconfig delete-environment --application-id $APP_ID --environment-id $ENV_ID
  done

  # List and delete all configuration profiles for this application
  PROFILES=$(aws appconfig list-configuration-profiles --application-id $APP_ID --query 'Items[*].Id' --output text)
  for PROFILE_ID in $PROFILES
  do
    echo "  Deleting configuration profile $PROFILE_ID"
    
    # Delete all hosted configuration versions for this profile
    VERSIONS=$(aws appconfig list-hosted-configuration-versions --application-id $APP_ID --configuration-profile-id $PROFILE_ID --query 'Items[*].VersionNumber' --output text)
    for VERSION in $VERSIONS
    do
      echo "    Deleting hosted configuration version $VERSION"
      aws appconfig delete-hosted-configuration-version --application-id $APP_ID --configuration-profile-id $PROFILE_ID --version-number $VERSION
    done

    # Delete the configuration profile
    aws appconfig delete-configuration-profile --application-id $APP_ID --configuration-profile-id $PROFILE_ID
  done

  # Delete the application
  echo "  Deleting application $APP_ID"
  aws appconfig delete-application --application-id $APP_ID
done

echo "All AppConfig resources have been deleted."
