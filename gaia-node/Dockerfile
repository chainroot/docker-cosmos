# Stage 1: Build stage
FROM golang:1.18-alpine AS go-builder
ARG arch=x86_64

ENV GAIA_VERSION=v9.1.1
ENV LIBWASMVM_VERSION=v1.2.1
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

# Download Gaia and extract tgz
ADD https://github.com/cosmos/gaia/archive/refs/tags/${GAIA_VERSION}.tar.gz ${GAIA_VERSION}.tar.gz
RUN tar -xzf ${GAIA_VERSION}.tar.gz && \
  cd gaia-${GAIA_VERSION#v} && \
  LEDGER_ENABLED=true BUILD_TAGS=muslc LDFLAGS="-linkmode=external -extldflags \"-L/code/mimalloc/build -lmimalloc -Wl,-z,muldefs -static\"" make install

# Stage 2: Final stage
FROM alpine:3

RUN apk add --no-cache lz4 tar gettext && \
    addgroup -g 1211 gaia && \
    adduser -G gaia -u 1210 -D -h /gaia gaia && \
    mkdir -p /gaia/.gaia/config /gaia/.gaia/data && \
    chown gaia:gaia -R /gaia

COPY ./config /gaia/config-sample
COPY ./entrypoint.sh /gaia
RUN chown gaia:gaia /gaia/entrypoint.sh && \
    chmod +x /gaia/entrypoint.sh

USER gaia
WORKDIR /gaia

COPY --from=go-builder /go/bin/gaiad /usr/local/bin/gaiad

# rest, grpc, p2p, rpc
EXPOSE 1317 9090 26656 26657

CMD ["sh", "-c", "/gaia/entrypoint.sh"]
