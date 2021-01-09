#!/bin/bash -eu
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")"; pwd)" # Figure out where the script is running
. "$SCRIPT_DIR"/lib/robust-bash.sh

require_env_var GITHUB_ACTOR

git config user.email "${GITHUB_ACTOR}@users.noreply.github.com"
git config user.name "${GITHUB_ACTOR}"

# It's easier to read the release notes from the standard version tool before it runs
RELEASE_NOTES="$(npx standard-version --dry-run | awk 'BEGIN { flag=0 } /^---$/ { if (flag == 0) { flag=1 } else { flag=2 }; next } flag == 1')"

if [ "$(echo "$RELEASE_NOTES" | wc -l)" -eq 1 ] ; then    
    echo "ERROR: This release would have no release notes. Does it include changes?"
    echo "   - You must have at least one fix / feat commit to generate release notes"
    echo "*** STOPPING RELEASE PROCESS ***"  
    exit 1
fi

RELEASE_NOTES="${RELEASE_NOTES//'%'/'%25'}"
RELEASE_NOTES="${RELEASE_NOTES//$'\n'/'%0A'}"
RELEASE_NOTES="${RELEASE_NOTES//$'\r'/'%0D'}"

echo "::set-output name=notes::$RELEASE_NOTES"

git log | head

npm install
npm run release

$($SCRIPT_DIR/lib/semver-from-git.sh)
$SCRIPT_DIR/lib/semver-from-git.sh

echo "::set-output name=version::$GIT_EXACT_TAG"

git push --follow-tags
