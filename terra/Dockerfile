FROM golang:1.20-alpine AS go-builder
ARG arch=x86_64

ENV TERRA_VERSION=v2.4.1
ENV SKIP_VERSION=v2.4.1
ENV CHAIN_ID=phoenix-1
ENV LIBWASMVM_VERSION=v1.1.1

ENV MIMALLOC_RESERVE_HUGE_OS_PAGES=1
ENV PACKAGES git cmake ca-certificates build-base curl make libc-dev bash gcc linux-headers eudev-dev python3 libusb-dev coreutils
ENV SKIP_REPO=https://raw.githubusercontent.com/skip-mev/config/main/${CHAIN_ID}/${SKIP_VERSION}

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

# Download Terra
ADD https://github.com/terra-money/core/archive/refs/tags/${TERRA_VERSION}.tar.gz ${TERRA_VERSION}.tar.gz
RUN tar xzf ${TERRA_VERSION}.tar.gz && \
    mv core-${TERRA_VERSION#v} terra

WORKDIR /code/terra

# Replace tendermint with skip-mev-tendermint
# TODO: add arg for skip-mev-tendermint enable/disable
RUN MEV_TENDERMINT_VERSION=$(curl -s ${SKIP_REPO}/mev-tendermint_version.txt) && \ 
    go mod edit -replace \
    github.com/tendermint/tendermint=github.com/skip-mev/mev-tendermint@${MEV_TENDERMINT_VERSION} && \
    go mod tidy

RUN VERSION=${TERRA_VERSION#v} LEDGER_ENABLED=true BUILD_TAGS=muslc LDFLAGS="-linkmode=external -extldflags \"-L/code/mimalloc/build -lmimalloc -Wl,-z,muldefs -static\"" make build 

FROM alpine:3

RUN apk add --no-cache lz4 tar gettext && \
    addgroup -g 1211 terra && \
    adduser -G terra -u 1210 -D -h /terra terra && \
    chown terra:terra -R /terra

COPY ./config /terra/config-sample
COPY ./entrypoint.sh /terra

RUN chown terra:terra /terra/entrypoint.sh && \
    chmod +x /terra/entrypoint.sh

USER terra
WORKDIR /terra

COPY --from=go-builder /code/terra/build/terrad /usr/local/bin/terrad

# rest, grpc, p2p, rpc
EXPOSE 1317 9090 26656 26657

CMD ["sh", "-c", "/terra/entrypoint.sh"]
