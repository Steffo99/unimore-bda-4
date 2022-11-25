#!/usr/bin/env bash
repo=$(git rev-parse --show-toplevel)
unlink "$repo/data/neo4j"
ln -s "$1" "$repo/data/neo4j"

# Example call:
# ./create-neo4j-desktop-link.sh "/home/steffo/.config/Neo4j Desktop/Application/relate-data/dbmss/dbms-13367bfc-b56d-418c-a9bd-c8c3932e1e0e"