#!/bin/bash

CMD="${1}"

if [ "${CMD}" == "upgrade" ]; then
    echo "You are running the Deno snap. The upgrade command is unavailable."
    echo "The snap is updated automatically after a new release of Deno."
    echo "You can force an update by running the command:"
    echo "    snap refresh deno"
    echo ""
    echo "If you think there is an issue, create an issue at https://github.com/Lukewh/deno-snap"
    exit 1
fi

exec $SNAP/deno "${@}"
