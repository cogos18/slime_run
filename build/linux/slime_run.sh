#!/bin/sh
echo -ne '\033c\033]0;Slime Run\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/slime_run.x86_64" "$@"
