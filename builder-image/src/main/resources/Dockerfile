FROM ubuntu:20.04

ENV TZ="Europe/Moscow"
RUN ln -snf "/usr/share/zoneinfo/${TZ}" /etc/localtime && \
    echo "${TZ}" > /etc/timezone && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
      ca-certificates \
      git \
      g++ \
      make \
      libstdc++-9-dev

ADD ["cmake.tar.gz", "/opt"]
ADD ["boost.tar.gz", "/usr/local/lib"]

ENV PATH="/opt/cmake-@cmake.version@-Linux-x86_64/bin:${PATH}" \
    BOOST_HOME="/usr/local/lib/boost-@boost.version@-x64-gcc9"

RUN revision="@app.version@" && \
    output_file="@output.file@" && \
    source_dir="$(mktemp -d)" && \
    git clone "https://github.com/mabrarov/asio_samples.git" "${source_dir}" && \
    git -C "${source_dir}" checkout "${revision}" && \
    build_dir="$(mktemp -d)" && \
    cmake \
      -D CMAKE_SKIP_BUILD_RPATH=ON \
      -D CMAKE_BUILD_TYPE=RELEASE \
      -D Boost_USE_STATIC_LIBS=ON \
      -D Boost_NO_SYSTEM_PATHS=ON \
      -D BOOST_INCLUDEDIR="${BOOST_HOME}/include" \
      -D BOOST_LIBRARYDIR="${BOOST_HOME}/lib" \
      -D MA_TESTS=OFF \
      -D MA_QT=OFF \
      -S "${source_dir}" \
      -B "${build_dir}" && \
    cmake --build "${build_dir}" --target ma_echo_server && \
    mkdir -p "$(dirname "${output_file}")" && \
    tar -C "${build_dir}/examples/ma_echo_server" -czf "${output_file}" ma_echo_server && \
    rm -rf "${build_dir}" && \
    rm -rf "${source_dir}"

CMD ["/usr/bin/cat", "@output.file@"]

LABEL name="@docker.repository@" \
    version="@project.version@" \
    release="@project.version@" \
    build-date="@git.commit.time@" \
    vcs-url="@git.remote.origin.url@" \
    vcs-type="git" \
    vcs-ref="@git.commit.id@"
