#!/usr/bin/env bash

mkdir -p data/temp

while [ $# -gt 2 ]; do
    cp $1 data/temp
    shift
done

code/makeStudy.R
code/bindSpecies.R $1 $2

rm -rf data/temp