#!/usr/bin/env bash

repo=$(git rev-parse --show-toplevel)
cwd=$(pwd)
data_files=$(ls $repo/data/cratesio/*/data/*.csv)

cd "$repo"

for file in $data_files; do
    echo "Fixing data file $file..."
    basefilename=$(basename $file)
    sed --expression='s=\\=\\\\=g' $file > "$repo/data/neo4j/import/$basefilename"
done

cd "$cwd"