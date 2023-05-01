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

# pull the nodes
# group by repository
# map to a new object
#  repository: nameWithOwner
#  pullRequests: map to a new object
#  title: title
#  url: url

JQ_TRANSFORM="""
.data.search.nodes |
group_by(.repository.nameWithOwner) |
map({
  repository: .[0].repository.nameWithOwner,
  repositoryUrl: .[0].repository.url,
  pullRequests: map({
    title: .title,
    url: .url,
  })
})
"""

gh api graphql -f query="$GET_CONTRIBUTIONS_QUERY" | jq -r "$JQ_TRANSFORM" | jq -s -c
