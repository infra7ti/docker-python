ARG DISTRO=debian
ARG TARGET_OS=bookworm
ARG TARGET_VARIANT=-slim
FROM ${DISTRO}:${TARGET_OS}${TARGET_VARIANT}

# Needed for source shell functions into this Dockerfile
SHELL ["/bin/bash", "-c"]

# ensure local python is preferred over distribution python
ENV PATH /usr/local/bin:$PATH

# http://bugs.python.org/issue19846
# > At the moment, setting "LANG=C" on a Linux system
# *fundamentally breaks Python 3*, and that's not OK.
ENV LANG C.UTF-8

ARG PYTHON_SERIES
ARG TARGET_OS=bookworm
COPY ${TARGET_OS}/pyenv.${PYTHON_SERIES:-3.12} /usr/src/python/pyenv
COPY libhelper/* /usr/src/python/

RUN set -eu; \
    source /usr/src/python/pyenv; \
    source /usr/src/python/pybuildhelper; \
    \
    apt-get update; \
    apt-get dist-upgrade -y --autoremove; \
    \
    # runtime dependencies \
    echo "${REQUIRES}" | xargs \
        apt-get install -y \
            --no-install-recommends \
            --no-install-suggests \
    ; \
    # build dependencies \
    echo "${BUILD_REQUIRES}" | xargs \
        apt-get install -y \
            --no-install-recommends \
            --no-install-suggests \
    ; \
    # -- get the Python source code ------------------------------------------ \
    __get_source "${PYTHON_VERSION}" \
    ; \
    # -- configure the source for building ----------------------------------- \
    gnuArch="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"; \
    __configure \
        --build="${gnuArch}" \
        --enable-optimizations \
        --enable-option-checking=fatal \
        --enable-shared \
        --with-lto \
        --with-system-expat \
        --without-ensurepip \
        ${PYTHON_EXTRA_BUILD_OPTS} \
        $([ ${PYTHON_SERIES//.*/} -gt 2 ] && \
            echo "--enable-loadable-sqlite-extensions") \
    ; \
    # -- build python from source -------------------------------------------- \
    export EXTRA_CFLAGS="$(dpkg-buildflags --get CFLAGS)"; \
    export LDFLAGS="$(dpkg-buildflags --get LDFLAGS)"; \
    export LDFLAGS="${LDFLAGS:--Wl},--strip-all"; \
    __make \
    ; \
    # -- install python to system -------------------------------------------- \
    savedAptMark="$(apt-mark showmanual)"; \
    __make_install; \
        apt-mark auto '.*' > /dev/null; \
        apt-mark manual $savedAptMark; \
        find /usr/local \
            -type f \
            -executable -not \( -name '*tkinter*' \) \
            -exec ldd '{}' ';' \
                | awk '/=>/ { \
                    so = $(NF-1); \
                    if (index(so, "/usr/local/") == 1) { next }; \
                    gsub("^/(usr/)?", "", so); \
                    printf "*%s\n", so \
                }' \
                | sort -u \
                | xargs -r dpkg-query --search \
                | cut -d: -f1 \
                | sort -u \
                | xargs -r apt-mark manual \
    ; \
    # -- DEB Package cleanup ------------------------------------------------- \
    echo "${BUILD_REQUIRES}" | xargs \
        apt-get purge -y \
            --auto-remove \
            -o APT::AutoRemove::RecommendsImportant=false; \
    apt-get autoremove -y \
        --purge \
        -o APT::AutoRemove::RecommendsImportant=false; \
    apt-get -y clean; \
    rm -rf /var/lib/apt/lists/*

CMD ["python"]

# vim: ts=4:sw=4:sts=4:et
