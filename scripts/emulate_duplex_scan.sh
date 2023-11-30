#!/usr/bin/env bash

help()
{
   echo "$(basename $0) PDF-src-odd-pages PDF-src-even-pages PDF-destfile"
}

ARGC=$#

file_A=$1
file_B=$2
output_file=$3

if [ $ARGC -ne 3 ]; then
   help
   exit 1
fi

qpdf --collate --empty --pages "$file_A" "$file_B" z-1 -- "$output_file"

