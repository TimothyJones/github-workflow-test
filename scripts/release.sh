#!/bin/bash -eu
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")"; pwd)" # Figure out where the script is running
. "$SCRIPT_DIR"/lib/robust-bash.sh

require_env_var GITHUB_ACTOR

git config user.email "${GITHUB_ACTOR}@users.noreply.github.com"
git config user.name "${GITHUB_ACTOR}"

# It's easier to read the release notes from the standard version tool before it runs
RELEASE_NOTES="$(npx standard-version --dry-run | awk 'BEGIN { flag=0 } /^---$/ { if (flag == 0) { flag=1 } else { flag=2 }; next } flag == 1')"

npm install
npm run release

echo "$RELEASE_NOTES"

git push --follow-tags
