#!/usr/bin/env bash
export NEO4J_USERNAME="neo4j"
export NEO4J_PASSWORD="neo4j"

echo "Altering password..."
cypher-shell --database="system" --non-interactive --fail-fast 'ALTER CURRENT USER SET PASSWORD FROM "neo4j" TO "unimore-big-data-analytics-4"'
