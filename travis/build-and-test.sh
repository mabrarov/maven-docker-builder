#!/bin/bash

set -e

maven_runner() {
  if [[ "${MAVEN_WRAPPER}" -ne 0 ]]; then
    printf "%q" "${TRAVIS_BUILD_DIR}/mvnw"
  else
    echo "mvn"
  fi
}

maven_settings() {
  maven_settings_file="${TRAVIS_BUILD_DIR}/travis/settings.xml"
  if [[ -f "${maven_settings_file}" ]]; then
    printf " %s %q" "--settings" "${maven_settings_file}"
  fi
}

build_maven_project() {
  build_cmd="$(maven_runner)$(maven_settings)"
  build_cmd="${build_cmd:+${build_cmd} }--file $(printf "%q" "${TRAVIS_BUILD_DIR}/pom.xml")"
  build_cmd="${build_cmd:+${build_cmd} }--batch-mode"

  if [[ "${DOCKER_MAVEN_PLUGIN_VERSION}" != "" ]]; then
    build_cmd="${build_cmd:+${build_cmd} }--define docker-maven-plugin.version=$(printf "%q" "${DOCKER_MAVEN_PLUGIN_VERSION}")"
  fi

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
  project_version_cmd="$(maven_runner)$(maven_settings)"
  project_version_cmd="${project_version_cmd:+${project_version_cmd} }--file $(printf "%q" "${TRAVIS_BUILD_DIR}/pom.xml")"
  project_version_cmd="${project_version_cmd:+${project_version_cmd} }--batch-mode --non-recursive"
  project_version_cmd="${project_version_cmd:+${project_version_cmd} }--define expression=project.version"
  project_version_cmd="${project_version_cmd:+${project_version_cmd} }org.apache.maven.plugins:maven-help-plugin:3.2.0:evaluate"
  maven_project_version="$(eval "${project_version_cmd}" | sed -n -e '/^\[.*\]/ !{ /^[0-9]/ { p; q } }')"

  image_name="${DOCKERHUB_USER}/maven-docker-builder-app:${maven_project_version}"
  echo "Running container created from ${image_name} image"
  docker run --rm "${image_name}" --help
}

main() {
  build_maven_project "${@}"
  test_images "${@}"
}

main "${@}"
