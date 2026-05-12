#!/bin/bash
# Convert XCF (GIMP 3) to ORA (OpenRaster) format.
# Usage: ./xcf-to-ora.sh <input.xcf> <output.ora>
#
# Requires: GIMP 3.x
# GIR dependencies: gir1.2-cairo-1.0 gir1.2-pango-1.0 gir1.2-gdkpixbuf-2.0 gir1.2-gtk-3.0

set -euo pipefail

INPUT="${1:?Usage: $0 <input.xcf> <output.ora>}"
OUTPUT="${2:?Usage: $0 <input.xcf> <output.ora>}"

if [ ! -f "$INPUT" ]; then
    echo "Error: input file not found: $INPUT" >&2
    exit 1
fi

# Convert absolute paths
INPUT="$(cd "$(dirname "$INPUT")" && pwd)/$(basename "$INPUT")"
OUTPUT_DIR="$(cd "$(dirname "$OUTPUT")" && pwd)"
OUTPUT="$OUTPUT_DIR/$(basename "$OUTPUT")"

GIMP_LOG=$(mktemp)

gimp --no-data --no-fonts -i --quit \
  --batch-interpreter python-fu-eval \
  -b "
image = Gimp.file_load(Gimp.RunMode.NONINTERACTIVE, Gio.file_new_for_path('$INPUT'))
Gimp.file_save(Gimp.RunMode.NONINTERACTIVE, image, Gio.file_new_for_path('$OUTPUT'))
image.delete()
" >"$GIMP_LOG" 2>&1 || true

if [ -f "$OUTPUT" ]; then
    echo "Converted: $OUTPUT"
    rm -f "$GIMP_LOG"
else
    echo "Error: conversion failed for $INPUT" >&2
    echo "--- GIMP output ---" >&2
    cat "$GIMP_LOG" >&2
    rm -f "$GIMP_LOG"
    exit 1
fi
