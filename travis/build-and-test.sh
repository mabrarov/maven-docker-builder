#!/bin/bash

set -e

build_maven_project() {
  if [[ "${MAVEN_WRAPPER}" -ne 0 ]]; then
    build_cmd="${build_cmd:+${build_cmd} }$(printf "%q" "${TRAVIS_BUILD_DIR}/mvnw")"
  else
    build_cmd="${build_cmd:+${build_cmd} }mvn"
  fi

  maven_settings_file="${TRAVIS_BUILD_DIR}/travis/settings.xml"
  if [[ -f "${maven_settings_file}" ]]; then
    build_cmd="${build_cmd:+${build_cmd} }--settings $(printf "%q" "${maven_settings_file}")"
  fi

  build_cmd="${build_cmd:+${build_cmd} }--file $(printf "%q" "${TRAVIS_BUILD_DIR}/pom.xml")"
  build_cmd="${build_cmd:+${build_cmd} }--batch-mode"

  if [[ "${DOCKERHUB_USER}" != "" ]]; then
    build_cmd="${build_cmd:+${build_cmd} }--define docker.image.registry=$(printf "%q" "${DOCKERHUB_USER}")"
  fi

  if [[ "${APP_VERSION}" != "" ]]; then
    build_cmd="${build_cmd:+${build_cmd} }--define app.version=$(printf "%q" "${APP_VERSION}")"
  fi

  if [[ "${CMAKE_VERSION}" != "" ]]; then
    build_cmd="${build_cmd:+${build_cmd} }--define cmake.version=$(printf "%q" "${CMAKE_VERSION}")"
  fi

  if [[ "${CMAKE_SHA256}" != "" ]]; then
    build_cmd="${build_cmd:+${build_cmd} }--define cmake.sha256=$(printf "%q" "${CMAKE_SHA256}")"
  fi

  if [[ "${BOOST_VERSION}" != "" ]]; then
    build_cmd="${build_cmd:+${build_cmd} }--define boost.version=$(printf "%q" "${BOOST_VERSION}")"
  fi

  if [[ "${BOOST_SHA256}" != "" ]]; then
    build_cmd="${build_cmd:+${build_cmd} }--define boost.sha256=$(printf "%q" "${BOOST_SHA256}")"
  fi

  build_cmd="${build_cmd:+${build_cmd} }package"

  echo "Building with: ${build_cmd}"
  eval "${build_cmd}"

  docker images
}

test_images() {
  maven_project_version="$(mvn \
    --file "${TRAVIS_BUILD_DIR}/pom.xml" \
    --batch-mode \
    --non-recursive \
    --define expression=project.version \
    org.apache.maven.plugins:maven-help-plugin:3.2.0:evaluate \
    | sed -n -e '/^\[.*\]/ !{ /^[0-9]/ { p; q } }')"

  image_name="${DOCKERHUB_USER}/maven-docker-builder-app:${maven_project_version}"
  echo "Running container created from ${image_name} image"
  docker run --rm "${image_name}" --help
}

main() {
  build_maven_project "${@}"
  test_images "${@}"
}

main "${@}"
