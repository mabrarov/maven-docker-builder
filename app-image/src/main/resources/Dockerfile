FROM gcr.io/distroless/cc-debian10

ADD ["rootfs.tar", "/"]

USER nonroot

ENTRYPOINT ["/opt/ma_echo_server/ma_echo_server"]

LABEL name="@docker.repository@" \
    version="@project.version@" \
    release="@project.version@" \
    build-date="@git.commit.time@" \
    vcs-url="@git.remote.origin.url@" \
    vcs-type="git" \
    vcs-ref="@git.commit.id@"
