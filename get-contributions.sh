#!/bin/bash
#
# get a list of merged pull requests from github

AUTHOR=${1}

GET_CONTRIBUTIONS_QUERY="""
query {
  search(
    query: \"is:pr is:merged is:public -user:${AUTHOR} author:${AUTHOR}\",
    type: ISSUE,
    first: 100
  ) {
    nodes {
      ... on PullRequest {
        title
        url
        repository {
          url
          nameWithOwner
        }
      }
    }
  }
}
"""

gh api graphql -f query="$GET_CONTRIBUTIONS_QUERY" |
	jq -r '.data.search.nodes[] | .' -c
