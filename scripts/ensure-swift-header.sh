#!/bin/bash
set -euo pipefail

if [[ "$#" -eq 0 ]]; then
  exit 0
fi

repo_root="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
project_name="$(basename "$repo_root")"
author_name="$(whoami)"
date_str="$(date +"%-m/%-d/%y")"
copyright_line="//  Copyright © 2026 Santaris Technologies. All rights reserved."

for target_file in "$@"; do
  if [[ "${target_file}" == file://* ]]; then
    target_file="${target_file#file://}"
  fi

  if [[ "${target_file}" != /* ]]; then
    target_file="${PWD}/${target_file}"
  fi

  if [[ "${target_file}" != *.swift ]]; then
    continue
  fi

  if [[ ! -f "${target_file}" ]]; then
    continue
  fi

  if python3 - "$target_file" <<'PY'
import sys
from pathlib import Path

text = Path(sys.argv[1]).read_text(encoding="utf-8", errors="ignore")
sys.exit(0 if "Created by " in text[:400] else 1)
PY
  then
    continue
  fi

  file_name="$(basename "${target_file}")"
  tmp_file="$(mktemp)"
  {
    echo "//"
    echo "//  ${file_name}"
    echo "//  ${project_name}"
    echo "//"
    echo "//  Created by ${author_name} on ${date_str}."
    echo "${copyright_line}"
    echo "//"
    echo
    cat "${target_file}"
  } > "${tmp_file}"

  mv "${tmp_file}" "${target_file}"
done
