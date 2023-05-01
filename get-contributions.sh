#!/bin/bash
#
# get a list of merged pull requests from github

AUTHOR=${1}
MY_CONTRIBUTIONS_URL="https://api.github.com/search/issues?q=is:pr+is:merged+is:public+-user:${AUTHOR}+author:${AUTHOR}&sort=merged"

# read contributions into an array
readarray -t contributions < <(curl -s "$MY_CONTRIBUTIONS_URL" | jq -r '.items[]' -c)

# loop over each item and get the repository full_name from item.repository_url, then add it to the item and output the array

for i in "${!contributions[@]}"; do
	repo_url=$(echo "${contributions[$i]}" | jq -r '.repository_url')
	repo_name=$(curl -s "$repo_url" | jq -r '.full_name')
	contributions[$i]=$(echo "${contributions[$i]}" | jq --arg repo_name "$repo_name" '. + {repo_name: $repo_name}')
done

# output the array
echo "${contributions[@]}" | jq -s -c
