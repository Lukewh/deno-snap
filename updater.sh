#!/bin/bash
date
json=$(curl --silent "https://api.github.com/repos/denoland/deno/releases/latest")

BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

cd "$BASE_DIR"

git pull origin master

current_version=""

if [ -f "current_version" ]; then
    current_version=$(cat "current_version")
fi

latest_version=$(echo "$json" | jq -r 'if .prerelease == false then .tag_name else null end')

echo "$latest_version"

if [ "$current_version" != "$latest_version" ]; then
    echo "Update to $latest_version"
    sed 's/\$version/'${latest_version}'/g' "_snapcraft.yaml" > "snapcraft.yaml"
    echo "Updated"

    git commit -a -m "Update to $latest_version"
    git push origin master

    echo "$latest_version"> "current_version"
fi

