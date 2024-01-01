ARG GO_VERSION
FROM golang:$GO_VERSION-alpine AS go-builder
ARG arch=x86_64
ARG WASM_VERSION
ARG BIN_VERSION
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
ADD https://github.com/CosmWasm/wasmvm/releases/download/${WASM_VERSION}/libwasmvm_muslc.aarch64.a libwasmvm_muslc.aarch64.a
ADD https://github.com/CosmWasm/wasmvm/releases/download/${WASM_VERSION}/libwasmvm_muslc.x86_64.a libwasmvm_muslc.x86_64.a
ADD https://github.com/CosmWasm/wasmvm/releases/download/${WASM_VERSION}/checksums.txt checksums.txt

RUN sha256sum -c --ignore-missing --status checksums.txt && \
    cp libwasmvm_muslc.`uname -m`.a /lib/libwasmvm_muslc.a

# Download Terra
ADD https://github.com/terra-money/core/archive/refs/tags/${BIN_VERSION}.tar.gz ${BIN_VERSION}.tar.gz
RUN tar xzf ${BIN_VERSION}.tar.gz && \
    mv core-${BIN_VERSION#v} terra

WORKDIR /code/terra

RUN VERSION=${BIN_VERSION#v} LEDGER_ENABLED=true BUILD_TAGS=muslc LDFLAGS="-linkmode=external -extldflags \"-L/code/mimalloc/build -lmimalloc -Wl,-z,muldefs -static\"" make build 

FROM alpine:3

RUN apk add --no-cache lz4 tar gettext && \
    addgroup -g 1211 terra && \
    adduser -G terra -u 1210 -D -h /terra terra && \
    chown terra:terra -R /terra

COPY ./entrypoint.sh /terra

RUN chown terra:terra /terra/entrypoint.sh && \
    chmod +x /terra/entrypoint.sh

USER terra
WORKDIR /terra

COPY --from=go-builder /code/terra/build/terrad /usr/local/bin/terrad

    #  rest, grpc, p2p, rpc
EXPOSE 1317 9090 26656 26657

CMD ["sh", "-c", "/terra/entrypoint.sh"]