#!/bin/sh

set -eu

if [ "$#" -ne 2 ]; then
  echo "Usage: ./builder.sh <github-repo> <docker-image>" >&2
  exit 1
fi

github_repo=$1
docker_image=$2

tmp_dir=$(mktemp -d)
trap 'rm -rf "$tmp_dir"' 0
trap 'exit 1' HUP INT TERM

# Clone the GitHub repository
git clone --depth 1 "https://github.com/${github_repo}.git" "$tmp_dir/repo"

# Build the Docker image
docker build -t "$docker_image" "$tmp_dir/repo"

# Push the image to Docker Hub
docker push "$docker_image"