# Stage 1: Build stage
FROM golang:1.20-alpine AS go-builder
ARG arch=x86_64

ENV OSMO_VERSION=v20.1.2
ENV LIBWASMVM_VERSION=v1.3.0
ENV PACKAGES git cmake ca-certificates build-base curl make libc-dev bash gcc linux-headers eudev-dev python3 libusb-dev coreutils

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

# Install libraries and verify checksums
ADD https://github.com/CosmWasm/wasmvm/releases/download/${LIBWASMVM_VERSION}/libwasmvm_muslc.aarch64.a libwasmvm_muslc.aarch64.a
ADD https://github.com/CosmWasm/wasmvm/releases/download/${LIBWASMVM_VERSION}/libwasmvm_muslc.x86_64.a libwasmvm_muslc.x86_64.a
ADD https://github.com/CosmWasm/wasmvm/releases/download/${LIBWASMVM_VERSION}/checksums.txt checksums.txt
RUN sha256sum -c --ignore-missing --status checksums.txt && \
    cp libwasmvm_muslc.`uname -m`.a /lib/libwasmvm_muslc.a

# Download Osmo and extract tgz 
ADD https://github.com/osmosis-labs/osmosis/archive/refs/tags/${OSMO_VERSION}.tar.gz ${OSMO_VERSION}.tar.gz
RUN tar xzf ${OSMO_VERSION}.tar.gz && \
  cd osmosis-${OSMO_VERSION#v} && \
  LEDGER_ENABLED=true BUILD_TAGS=muslc LDFLAGS="-linkmode=external -extldflags \"-L/code/mimalloc/build -lmimalloc -Wl,-z,muldefs -static\"" make install VERSION=${OSMO_VERSION#v}

# Stage 2: Final stage
FROM alpine:3

RUN apk add --no-cache lz4 tar gettext && \
    addgroup -g 1211 osmosis && \
    adduser -G osmosis -u 1210 -D -h /osmosis osmosis && \
    chown osmosis:osmosis -R /osmosis

COPY ./config /osmosis/config-sample
COPY ./entrypoint.sh /osmosis

RUN chown osmosis:osmosis /osmosis/entrypoint.sh && \
    chmod +x /osmosis/entrypoint.sh

USER osmosis
WORKDIR /osmosis

COPY --from=go-builder /go/bin/osmosisd /usr/local/bin/osmosisd

# rest, grpc, p2p, rpc
EXPOSE 1317 9090 26656 26657

CMD ["sh", "-c", "/osmosis/entrypoint.sh"]