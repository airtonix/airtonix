#!/bin/bash
#
# get a list of merged pull requests from github

AUTHOR=${1}
MY_CONTRIBUTIONS_URL="https://api.github.com/search/issues?q=is:pr+is:merged+is:public+-user:${AUTHOR}+author:${AUTHOR}&sort=merged"

curl -s "$MY_CONTRIBUTIONS_URL" | jq -r '.items' -c
