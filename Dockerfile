FROM alpine:edge AS builder

RUN apk add --no-cache popt && \
    apk add --no-cache \
    --virtual .build \
        make \
        libtool \
        automake \
        autoconf \
        libc-dev \
        popt-dev \
        gcc

COPY / /tmp/picotts
WORKDIR /tmp/picotts/pico
RUN ./autogen.sh &&  \
    ./configure --prefix=/opt && \
    make && \
    make install

FROM alpine:edge
COPY --from=builder /opt /opt
RUN apk add --no-cache popt
ENV PATH="/opt/bin:${PATH}"
WORKDIR /workdir
ENTRYPOINT ["pico2wave"]