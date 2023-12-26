# Stage 1: Build stage
ARG GO_VERSION
FROM golang:$GO_VERSION-alpine AS go-builder
ARG arch=x86_64

ARG BIN_VERSION
ARG WASM_VERSION
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

# Download Osmosis and extract tgz
ADD https://github.com/osmosis-labs/osmosis/archive/refs/tags/${BIN_VERSION}.tar.gz ${BIN_VERSION}.tar.gz
RUN tar -xzf ${BIN_VERSION}.tar.gz && \
  cd osmosis-${BIN_VERSION#v} && \
  LEDGER_ENABLED=true BUILD_TAGS=muslc LDFLAGS="-linkmode=external -extldflags \"-L/code/mimalloc/build -lmimalloc -Wl,-z,muldefs -static\"" make install VERSION=${BIN_VERSION#v}

# Stage 2: Final stage
FROM alpine:3

RUN apk add --no-cache lz4 tar gettext && \
    addgroup -g 1211 osmosis && \
    adduser -G osmosis -u 1210 -D -h /osmosis osmosis && \
    chown osmosis:osmosis -R /osmosis

COPY ./entrypoint.sh /osmosis
RUN chown osmosis:osmosis /osmosis/entrypoint.sh && \
    chmod +x /osmosis/entrypoint.sh

USER osmosis
WORKDIR /osmosis

COPY --from=go-builder /go/bin/osmosisd /usr/local/bin/osmosisd

# rest, grpc, p2p, rpc
EXPOSE 1317 9090 26656 26657

CMD ["sh", "-c", "/osmosis/entrypoint.sh"]