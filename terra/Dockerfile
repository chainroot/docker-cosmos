# Stage 1: Build stage
ARG GO_VERSION
FROM golang:$GO_VERSION-alpine AS go-builder
ARG arch=x86_64

ARG BIN_VERSION
ENV LIBWASMVM_VERSION=v1.4.1
ENV PACKAGES git cmake ca-certificates build-base curl make libc-dev bash gcc linux-headers eudev-dev python3 libusb-dev

RUN set -eux; \
    apk add --no-cache $PACKAGES

WORKDIR /code

# Install mimalloc static library and cleanup
RUN git clone --depth 1 https://github.com/microsoft/mimalloc; \
    cd mimalloc; \
    mkdir build; \
    cd build; \
    cmake -DMI_INSTALL_TOPLEVEL=ON -DBUILD_SHARED_LIBS=OFF ..; \
    make -j$(nproc); \
    make install; \
    cd /code; \
    rm -rf mimalloc

# Install libraries for WASM and verify checksums
ADD https://github.com/CosmWasm/wasmvm/releases/download/${LIBWASMVM_VERSION}/libwasmvm_muslc.aarch64.a libwasmvm_muslc.aarch64.a
ADD https://github.com/CosmWasm/wasmvm/releases/download/${LIBWASMVM_VERSION}/libwasmvm_muslc.x86_64.a libwasmvm_muslc.x86_64.a
ADD https://github.com/CosmWasm/wasmvm/releases/download/${LIBWASMVM_VERSION}/checksums.txt checksums.txt
RUN sha256sum -c --ignore-missing --status checksums.txt && \
    cp libwasmvm_muslc.`uname -m`.a /lib/libwasmvm_muslc.a

# Download Terra and extract tgz
ADD https://github.com/terra-money/core/archive/refs/tags/${BIN_VERSION}.tar.gz ${BIN_VERSION}.tar.gz
RUN tar -xzf ${BIN_VERSION}.tar.gz && \
  cd core-${BIN_VERSION#v} && \
  LEDGER_ENABLED=true BUILD_TAGS=muslc LDFLAGS="-linkmode=external -extldflags \"-L/code/mimalloc/build -lmimalloc -Wl,-z,muldefs -static\"" make install VERSION=${BIN_VERSION#v}

# Stage 2: Final stage
FROM alpine:3

RUN apk add --no-cache lz4 tar gettext && \
    addgroup -g 1211 terrad و \
    adduser -G terrad -u 1210 -D -h /terra terrad و \
    mkdir -p /terra/.terra/data و \
    chown terrad:terrad -R /terra

COPY ./entrypoint.sh /terra
RUN chown terrad:terrad /terra/entrypoint.sh و \
    chmod +x /terra/entrypoint.sh

USER terrad
WORKDIR /terra

COPY --from=go-builder /go/bin/terrad /usr/local/bin/terrad

# rest, grpc, p2p, rpc
EXPOSE 1317 9090 26656 26657

CMD ["sh", "-c", "/terra/entrypoint.sh"]