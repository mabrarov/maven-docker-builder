FROM ubuntu:20.04

ENV TZ="Europe/Moscow"
RUN ln -snf "/usr/share/zoneinfo/${TZ}" /etc/localtime && \
    echo "${TZ}" > /etc/timezone && \
    apt-get update && \
    apt-get install -y \
      curl \
      git \
      g++ \
      make \
      libstdc++-9-dev

ENV CMAKE_DIR="/opt/cmake"
ARG CMAKE_VERSION="3.18.2"
RUN mkdir -p "${CMAKE_DIR}" && \
    cmake_url="https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-Linux-x86_64.tar.gz" && \
    echo "Downloading CMake ${CMAKE_VERSION} from ${cmake_url} to ${CMAKE_DIR} directory" && \
    curl -jksSL "${cmake_url}" | tar -xzf - -C "${CMAKE_DIR}" --strip-components 1 && \
    "${CMAKE_DIR}/bin/cmake" --version

ENV BOOST_DIR="/opt/boost"
ARG BOOST_VERSION="1.74.0"
ARG BOOST_URL="https://dl.bintray.com/mabrarov/generic/boost"

RUN mkdir -p "${BOOST_DIR}" && \
    boost_archive_url="${BOOST_URL}/${BOOST_VERSION}/boost-${BOOST_VERSION}-x64-gcc$(gcc -dumpversion | sed -r 's/^([[:digit:]]+)(\..*)?$/\1/;t;d').tar.gz" && \
    echo "Downloading Boost from ${boost_archive_url}" && \
    curl -jksSL "${boost_archive_url}" | tar -xzf - -C "${BOOST_DIR}" --strip-components 1

ARG REVISION="master"
ARG OUTPUT_FILE="/out.tar.gz"

RUN source_dir="$(mktemp -d)" && \
    git clone "https://github.com/mabrarov/asio_samples.git" "${source_dir}" && \
    git -C "${source_dir}" checkout "${REVISION}" && \
    build_dir="$(mktemp -d)" && \
    "${CMAKE_DIR}/bin/cmake" \
      -D CMAKE_SKIP_BUILD_RPATH=ON \
      -D CMAKE_BUILD_TYPE=RELEASE \
      -D Boost_USE_STATIC_LIBS=ON \
      -D Boost_NO_SYSTEM_PATHS=ON \
      -D BOOST_INCLUDEDIR="${BOOST_DIR}/include" \
      -D BOOST_LIBRARYDIR="${BOOST_DIR}/lib" \
      -D MA_TESTS=OFF \
      -D MA_QT=OFF \
      -S "${source_dir}" \
      -B "${build_dir}" && \
    "${CMAKE_DIR}/bin/cmake" --build "${build_dir}" --target ma_echo_server && \
    mkdir -p "$(dirname "${OUTPUT_FILE}")" && \
    tar -C "${build_dir}/examples/ma_echo_server" -czf "${OUTPUT_FILE}" ma_echo_server && \
    rm -rf "${build_dir}" && \
    rm -rf "${source_dir}"

CMD ["/usr/bin/cat", "/out.tar.gz"]

LABEL name="@docker.repository@" \
    version="@project.version@" \
    release="@project.version@" \
    build-date="@git.commit.time@" \
    vcs-url="@git.remote.origin.url@" \
    vcs-type="git" \
    vcs-ref="@git.commit.id@"
