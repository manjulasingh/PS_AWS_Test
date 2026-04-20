#!/bin/sh
set -eu

echo "Container started."
echo "Working dir: $(pwd)"
echo "OUT_DIR: ${OUT_DIR}"
echo "FILE_TO_COPY: ${FILE_TO_COPY}"

# Ensure output dir exists (works for mounted dir too)
mkdir -p "${OUT_DIR}"

SRC="/app/${FILE_TO_COPY}"
DST="${OUT_DIR}/$(basename "${FILE_TO_COPY}")"

if [ ! -f "${SRC}" ]; then
  echo "ERROR: Source file not found in image: ${SRC}"
  echo "Tip: set FILE_TO_COPY to an existing file from your build context."
  exit 2
fi

cp -f "${SRC}" "${DST}"
echo "Copied ${SRC} -> ${DST}"

echo "Done. Exiting."
exit 0
