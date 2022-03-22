#!/bin/bash
date
json=$(curl --silent "https://api.github.com/repos/denoland/deno/releases/latest")

BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

if [ -f "$BASE_DIR/.env" ]; then
    . "$BASE_DIR/.env"
fi

cd "$BASE_DIR"

current_version=$(curl -H "Snap-Device-Series: 16" --silent "https://api.snapcraft.io/v2/snaps/info/deno")
current_version=$(echo "$current_version" | jq '.["channel-map"][0].version')

latest_version=$(echo "$json" | jq -r 'if .prerelease == false then .tag_name else null end')

echo "$latest_version"

if [ "$current_version" != "$latest_version" ]; then
    echo "Update to $latest_version"
    sed 's/\$version/'${latest_version}'/g' "_snapcraft.yaml" > "snapcraft.yaml"
    echo "Updated"

    git commit -a -m "Update to $latest_version"
    git push origin master

    echo "$latest_version"> "current_version"

    curl -d '{"snapName":"deno","oldVersion":"$current_version","newVersion":"$latest_version"}' -H "Content-Type: application/json" -X POST "$URL"
fi

