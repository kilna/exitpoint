#!/bin/bash

export image='kilna/exitpoint'
export short_desc='A container to run an exitpoint.sh script upon termination'
export platforms='linux/amd64,linux/386,linux/arm64,linux/arm/v6,linux/arm/v7'
export base_images=(busybox=busybox:uclibc alpine)
export main=busybox
export builder=exitpoint
export ver_regex='v[0-9]+\.[0-9]+\.[0-9]+(-[a-z0-9]+)?'
export git_branch=$(git branch | grep -F '*' | cut -f2- -d' ')

set -e -u -o pipefail

run() { echo "$@"; "$@"; }

error() { echo "$1" >&2; exit "${2:-1}"; }

description() {
  yq -r ".\"$version\".description // \"\"" CHANGELOG.yml
}

check_version() {
  if !(echo "$version" | grep -qE "$ver_regex"); then
    error "Must proivde a version in vX.Y.Z or vX.Y.Z-prerelease format";
  fi
  if [[ "$(description)" == '' ]]; then
    error "CHANGELOG.yml is missing entry for $version"
  fi
}

check_git_status() {
  if !(git status | grep -qF "up to date"); then
    error "Git working copy is not up to date"
  fi
  if !(git status | grep -qF "working tree clean"); then
    error "Git working tree is not clean"
  fi
  if [[ "$version" != *-* && "$git_branch" != 'main' ]]; then
    error "release must be on main branch for non-prerelease"
  fi
}

build() {
  for base_image in "${base_images[@]}"; do
    alias="$(echo "$base_image" | cut -d= -f1)"
    base_image="$(echo "$base_image" | rev | cut -d= -f1 | rev)"
    build_tag=$image:$(echo "$version" | sed -e 's/^v//')-${alias//:/-}
    run docker buildx build . -t $build_tag --build-arg base_image=$base_image \
      --progress plain --platform $platforms --push
    run docker pull $build_tag
  done
}

github_unrelease() {
  set +e
  gh release delete -y $version
  git push --delete origin $version
  set -e
}

github_release() {
  github_unrelease
  check_version
  check_git_status
  if [ $version == *-* ]; then \
    run gh release create -n "$(description)" --title $version $version \
      --target $git_branch --prerelease; \
  else \
    run gh release create -n "$(description)" --title $version $version; \
  fi
}

docker_install_pushrm() {
  [[ -e ~/.docker/cli-plugins/docker-pushrm ]] && return
  curl -o ~/.docker/cli-plugins/docker-pushrm -fsSL \
    https://github.com/christian-korneck/docker-pushrm/releases/download/v1.9.0/docker-pushrm_darwin_amd64
  chmod +x ~/.docker/cli-plugins/docker-pushrm
}

docker_release() {
  check_version
  build
  docker_install_pushrm
  for base_image in "${base_images[@]}" ; do
    alias="$(echo "$base_image" | cut -d= -f1)"
    run docker buildx imagetools create --tag $image:${alias//:/-} \
      $image:$(echo "$version" | sed -e 's/^v//')-${alias//:/-}
  done
  if [[ "$version" != *-* ]]; then
    run docker buildx imagetools create --tag $image:latest $image:$main
    run docker pushrm $image:latest --short "$short_desc"
  fi
}

release() {
  github_release
  docker_release
}

action='release'
export version
while (( $# > 0 )); do case "$1" in
  v*.*.*)          version="$1";;
  *release|build)  action='build';;
  *)               error "Unknown option $1"
esac; shift; done

$action

