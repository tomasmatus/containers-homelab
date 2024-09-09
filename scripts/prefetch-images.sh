#!/bin/bash

set -eu

kube_files=$(find . -mindepth 2 -maxdepth 2 -type f -regex '.*-kube.yaml$')
images=$(grep "image: " ${kube_files} | awk '{ print $3 }')

missing_images=()
for image in ${images}; do
  # if subcommand exits with error then add the image to the list
  if ! $(podman image exists "${image}"); then
    missing_images+=("${image}")
  fi
done

if [[ ${#missing_images[@]} -eq 0 ]]; then
  printf "Nothing to do.\n"
  exit 0
fi

printf "Pulling %d images:\n" ${#missing_images[@]}
printf "%s\n" "${missing_images[@]}"
printf "\n"
podman pull ${missing_images[@]}
