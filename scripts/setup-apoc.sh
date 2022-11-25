#!/usr/bin/env bash
repo=$(git rev-parse --show-toplevel)

echo "Creating plugins directory..."
mkdir --parents "$repo/data/neo4j/plugins"

echo "Installing Neo4j Apoc..."
wget 'https://github.com/neo4j/apoc/releases/download/5.5.0/apoc-5.5.0-core.jar' --output-document="$repo/data/neo4j/plugins/apoc-core.jar"

