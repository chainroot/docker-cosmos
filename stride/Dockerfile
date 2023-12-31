ARG GO_VERSION
FROM golang:$GO_VERSION-alpine AS go-builder
ARG arch=x86_64
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


# Download stride and build
ADD https://github.com/Stride-Labs/stride/archive/refs/tags/${BIN_VERSION}.tar.gz ${BIN_VERSION}.tar.gz
RUN tar -xzf ${BIN_VERSION}.tar.gz && \
    cd stride-${BIN_VERSION#v} && \
    LEDGER_ENABLED=true BUILD_TAGS="muslc badgerdb" LDFLAGS="-linkmode=external -extldflags \"-L/code/mimalloc/build -lmimalloc -Wl,-z,muldefs -static\"" make install VERSION=${BIN_VERSION#v}

# Stage 2: Create minimal runtime image
FROM alpine:3

ENV DAEMON_NAME="strided"
ENV DAEMON_HOME="/stride/.stride"

RUN apk add --no-cache lz4 tar gettext && \
    addgroup -g 1211 stride && \
    adduser -G stride -u 1210 -D -h /stride stride && \
    chown stride:stride -R /stride


COPY ./entrypoint.sh /stride

RUN chown stride:stride /stride/entrypoint.sh && \
    chmod +x /stride/entrypoint.sh

USER stride
WORKDIR /stride

COPY --from=go-builder /go/bin/strided /usr/local/bin/strided

    #  rest, grpc, p2p, rpc
EXPOSE 1317 9090 26656 26657

CMD ["sh", "-c", "/stride/entrypoint.sh"] 