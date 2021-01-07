#!/bin/bash -eu

echo "release"
RELEASE_NOTES="$(cat CHANGELOG.md | awk 'BEGIN { flag=0 } /^###? \[/ { if (flag == 0) { flag=1 } else { flag=2 }; next } flag == 1')"
echo "$RELEASE_NOTES"

npm install
npm run release

echo "$GITHUB_CONTEXT"

git push --follow-tags
