#!/usr/bin/env bash
repo=$(git rev-parse --show-toplevel)
export NEO4J_HOME="$repo/data/neo4j"
neo4j console
