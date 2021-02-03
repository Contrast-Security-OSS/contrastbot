#!/bin/bash

export HUBOT_SLACK_TOKEN=`aws ssm get-parameter --name ${SLACK_TOKEN_SSM_PARAMETER} --with-decryption --region us-east-1 --output json | jq -r '.Parameter.Value'`

bin/hubot -n $HUBOT_NAME --adapter slack