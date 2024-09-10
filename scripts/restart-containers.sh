#!/bin/bash

set -eu

DRY_RUN=""
PULL=""

print_help() {
  printf "Restart all containers\n"
  printf "Only run this script from the root of containers-homelab repository!\n\n"
  printf "Usage:\n"
  printf "  scripts/restart-containers.sh [options]\n\n"
  printf "Available options:\n"
  printf "  -p|--pull\tAlso run script to pre-pull new images\n"
  printf "  --dry-run\tRun in dry-run mode (does not pull or restart anything)\n"
  printf "  -h|--help\tPrint this menu\n"
}

parse_cmd() {
  while [[ $# -gt 0 ]]; do
    case $1 in
      --dry-run)
        DRY_RUN=1
        shift
      ;;

      -p|--pull)
        PULL=1
        shift
      ;;

      -h|--help)
        print_help
        exit 0
      ;;

      -*|--*)
      echo "Unknown option $1"
      exit 1
      ;;
    esac
  done
}

parse_cmd $*

if [[ -n ${PULL} ]]; then
  echo "pulling new images"
  if [[ -z ${DRY_RUN} ]]; then
    ./scripts/prefetch-images.sh
  fi
fi

kube_files=$(find . -mindepth 2 -maxdepth 2 -type f -regex '.*-kube.kube$' -printf "%f ")
service_names=$(echo "${kube_files}" | sed -E 's/\.kube\s/\.service /g')

cnt=0
for container in ${service_names}; do
  # Skip container service if it is not active (not running)
  if ! $(systemctl --user is-active ${container} > /dev/null) && [[ -z ${DRY_RUN} ]]; then
    printf "Skipping %s -- not active\n" ${container}
    continue
  fi

  # Use systemctl stop + start instead of restart as fully stopping first
  # makes sure the service is completely cleared out even with file descriptors etc
  printf "Restarting ${container}...\n"
  if [[ -z ${DRY_RUN} ]]; then
    systemctl --user stop ${container}
    systemctl --user start ${container}
  fi
  printf "Done\n"

  cnt=$((${cnt} + 1))
done

printf "Restarted %d containers\n" ${cnt}
