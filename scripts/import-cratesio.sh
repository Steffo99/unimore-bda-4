#!/usr/bin/env bash
set -e

export NEO4J_USERNAME="neo4j"
export NEO4J_PASSWORD="unimore-big-data-analytics-4"

repo=$(git rev-parse --show-toplevel)
cwd=$(pwd)
import_scripts=$(echo $repo/scripts/import-cratesio/$1*.cypher | sort)

cd "$repo"

for file in $import_scripts; do
    echo "Executing $file..."
    cypher-shell --fail-at-end --format verbose < $file
done

cd "$cwd"