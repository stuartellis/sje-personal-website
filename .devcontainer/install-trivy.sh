#!/usr/bin/env bash

# SPDX-FileCopyrightText: Waived by terms of license
#
# SPDX-License-Identifier: CC0-1.0
#
# From: https://github.com/casey/just/blob/master/www/install.sh
# Commit ID: 6d7df195575c25786b4e430c194fa0ea2fde8000
# Downloaded: 2024-02-25T08:08:00Z

set -eu

if [ -n "${GITHUB_ACTIONS-}" ]; then
  set -x
fi

# Check pipefail support in a subshell, ignore if unsupported
# shellcheck disable=SC3040
(set -o pipefail 2> /dev/null) && set -o pipefail

help() {
  cat <<'EOF'
Install a binary release of Trivy hosted on GitHub

USAGE:
    install [options]

FLAGS:
    -h, --help      Display this message
    -f, --force     Force overwriting an existing binary

OPTIONS:
    --tag TAG       Tag (version) to install, defaults to latest release
    --to LOCATION   Where to install the binary [default: ~/bin]
    --target TARGET
EOF
}

package=trivy
url=https://github.com/aquasecurity/trivy
releases=$url/releases

say() {
  echo "install: $*" >&2
}

err() {
  if [ -n "${td-}" ]; then
    rm -rf "$td"
  fi

  say "error: $*"
  exit 1
}

need() {
  if ! command -v "$1" > /dev/null 2>&1; then
    err "need $1 (command not found)"
  fi
}

force=false
while test $# -gt 0; do
  case $1 in
    --force | -f)
      force=true
      ;;
    --help | -h)
      help
      exit 0
      ;;
    --tag)
      tag=$2
      shift
      ;;
    --target)
      target=$2
      shift
      ;;
    --to)
      dest=$2
      shift
      ;;
    *)
      ;;
  esac
  shift
done

need curl
need install
need mkdir
need mktemp
need tar

if [ -z "${tag-}" ]; then
  need grep
  need cut
fi

if [ -z "${target-}" ]; then
  need cut
fi

if [ -z "${dest-}" ]; then
  dest="$HOME/bin"
fi

if [ -z "${tag-}" ]; then
  tag=$(
    curl --proto =https --tlsv1.2 -sSf \
      https://api.github.com/repos/aquasecurity/trivy/releases/latest |
    grep tag_name |
    cut -d'"' -f4
  )
fi

if [ -z "${target-}" ]; then
  # bash compiled with MINGW (e.g. git-bash, used in github windows runners),
  # unhelpfully includes a version suffix in `uname -s` output, so handle that.
  # e.g. MINGW64_NT-10-0.19044
  kernel=$(uname -s | cut -d- -f1)
  uname_target="$(uname -m)-$kernel"

  case $uname_target in
    aarch64-Linux)     target=Linux-ARM64;;
    arm64-Darwin)      target=macOS-ARM64;;
    x86_64-Darwin)     target=macOS-64bit;;
    x86_64-Linux)      target=Linux-64bit;;
    x86_64-MINGW64_NT) target=windows-64bit;;
    x86_64-Windows_NT) target=windows-64bit;;
    *)
      # shellcheck disable=SC2016
      err 'Could not determine target from output of `uname -m`-`uname -s`, please use `--target`:' "$uname_target"
    ;;
  esac
fi

case $target in
  windows-64bit) extension=zip; need unzip;;
  *)                      extension=tar.gz;;
esac

archive="$releases"/download/v"$tag"/"$package"_"$tag"_"$target"."$extension"

say "Repository:  $url"
say "Package:     $package"
say "Tag:         $tag"
say "Target:      $target"
say "Destination: $dest"
say "Archive:     $archive"

td=$(mktemp -d || mktemp -d -t tmp)

if [ "$extension" = "zip" ]; then
  curl --proto =https --tlsv1.2 -sSfL "$archive" > "$td/trivy.zip"
  unzip -d "$td" "$td/trivy.zip"
else
  curl --proto =https --tlsv1.2 -sSfL "$archive" | tar -C "$td" -xz
fi

if [ -e "$dest/trivy" ] && [ "$force" = false ]; then
  err "\`$dest/trivy\` already exists"
else
  mkdir -p "$dest"
  install -m 755 "$td/trivy" "$dest"
fi

rm -rf "$td"