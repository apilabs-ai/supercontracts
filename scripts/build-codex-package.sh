#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
package_dir="$repo_root/plugins/supercontracts-mcp"
output_dir="$repo_root/dist"
output_file="$output_dir/supercontracts-codex.zip"
staging_dir="$(mktemp -d)"

cleanup() {
  rm -rf "$staging_dir"
}
trap cleanup EXIT

mkdir -p "$output_dir"
rm -f "$output_file"

cp "$package_dir/plugin.json" "$staging_dir/plugin.json"
cp "$package_dir/README.md" "$staging_dir/README.md"
cp -R "$package_dir/skills" "$staging_dir/skills"
cp -R "$package_dir/assets" "$staging_dir/assets"

# Cursor keeps its existing environment-variable header configuration in the
# source package. The Codex archive declares the same credential as bearer
# API-key authentication without embedding or referencing a token value.
jq '
  .mcpServers.supercontracts |= (
    del(.headers) |
    . + {
      "extensions": {
        "com.openai": {
          "auth": {
            "type": "api_key",
            "headerScheme": "bearer"
          }
        }
      }
    }
  )
' "$package_dir/mcp.json" > "$staging_dir/mcp.json"

cd "$staging_dir"
zip -r "$output_file" \
  plugin.json \
  mcp.json \
  README.md \
  skills \
  assets

unzip -l "$output_file"
