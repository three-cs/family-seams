#!/bin/bash
set -x

# eval "$(jq -r '@sh "INPUT=\(.)"')"
INPUT=$(cat)

REGISTRATION_TIMEOUT=$(echo $INPUT | jq .registration_timeout --raw-output)
REGISTRATION=$(echo $INPUT | jq .registration --raw-output)
DOMAIN=$(echo $REGISTRATION | jq .DomainName --raw-output)

ROUTE_53_DOMAIN_REGION=us-east-1

PWD=$(pwd)

READY=false

DOMAIN_REGISTERED=$(aws route53domains list-domains --no-paginate --region $ROUTE_53_DOMAIN_REGION | jq ".Domains[].DomainName | select(. != null) | select(. == \"$DOMAIN\")" --raw-output)

if [[ "$DOMAIN_REGISTERED" ]]; then
  OUT="Domain [$DOMAIN_REGISTERED] Already Registered"
  READY=true
  HOSTED_ZONE=$(aws route53 list-hosted-zones --region $ROUTE_53_DOMAIN_REGION | jq ".HostedZones[] | select(. != null) | select(.Name == \"$DOMAIN.\") | .Id" --raw-output)
else
  DOMAIN_AVAILABLE=$(aws route53domains check-domain-availability --domain-name $DOMAIN --region $ROUTE_53_DOMAIN_REGION | jq '.Availability' --raw-output)
  if [[ "AVAILABLE" == "$DOMAIN_AVAILABLE" ]]; then
    echo $REGISTRATION > $PWD/registration.json

    OPERATION_ID=$(aws route53domains register-domain --region $ROUTE_53_DOMAIN_REGION --cli-input-json file://$PWD/registration.json | jq .OperationId --raw-output)

    if [[ -n $OPERATION_ID ]]; then
      TIME=0
      until [[ "SUCCESSFUL" == $(aws route53domains get-operation-detail --region $ROUTE_53_DOMAIN_REGION --operation-id $OPERATION_ID | jq .Status --raw-output) ]]; do
        sleep 10
        TIME=$(($TIME + 10))
        if [ "$TIME" -gt "$REGISTRATION_TIMEOUT" ]; then
          echo "Registration Timeout Exeeded"
          exit 1
        fi
      done

      OUT="Domain Registered after [$TIME] seconds"
      READY=true
      HOSTED_ZONE=$(aws route53 list-hosted-zones --region $ROUTE_53_DOMAIN_REGION | jq ".HostedZones[] | select(. != null) | select(.Name == \"$DOMAIN.\") | .Id" --raw-output)
    else
      echo "Failed to register [$DOMAIN]"
      exit 1
    fi
  else
    OUT="Domain [$DOMAIN_AVAILABLE]"
  fi
fi

echo "{\"out\":\"$OUT\", \"ready\":\"$READY\", \"hosted_zone\":\"$HOSTED_ZONE\"}" | jq .