#!/bin/bash
#
# repack.sh
#
# This script runs the Unix/Linux h5repack command line tool to create a
# copy of an existing HDF5 file with a new layout (i.e., chunking) and
# optionally, compression.
#
# NOTE: update the input/output file names accordingly
INPUT_FILE="DataBase_MC-IDW_12.h5"
OUTPUT_FILE="DataBase_MC-IDW_12c.h5"

echo "Starting h5repack process..."

# The core command; applies SHUFFLE, GZIP, and CHUNK to all datasets
# Based on a few test runs, the GZIP compression is quite poor
# (7% without SHUF; 25% with SHUF).
h5repack --verbose --enable-error-stack --filter=SHUF --filter=GZIP=5 --layout=CHUNK=72538x1 "$INPUT_FILE" "$OUTPUT_FILE"
# OPTIONS:
# --verbose, prints to console
# --enable-error-stack, provides more details error messaging
# --filter=SHUF, add shuffle filter to each dataset for improved chunking
# --filter=GZIP=5, add compression to each dataset
# --layout=CHUNK=72538x1, add chunking to each dataset (size of 1 row)

if [ $? -eq 0 ]; then
    echo "---"
    echo "SUCCESS: Repacking complete."
    echo "Original size:" $(du -h "$INPUT_FILE" | awk '{print $1}')
    echo "New compressed size:" $(du -h "$OUTPUT_FILE" | awk '{print $1}')
else
    echo "---"
    echo "ERROR: h5repack failed. Check verbose output above."
    exit 1
fi
