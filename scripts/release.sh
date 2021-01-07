#!/bin/bash -eu
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")"; pwd)" # Figure out where the script is running
. "$SCRIPT_DIR"/lib/robust-bash.sh

require_env_var GITHUB_ACTOR


echo "release"
RELEASE_NOTES="$(cat CHANGELOG.md | awk 'BEGIN { flag=0 } /^###? \[/ { if (flag == 0) { flag=1 } else { flag=2 }; next } flag == 1')"
echo "$RELEASE_NOTES"

git config user.email "${GITHUB_ACTOR}@users.noreply.github.com"
git config user.name "${GITHUB_ACTOR}"

npm install
npm run release

git push --follow-tags
