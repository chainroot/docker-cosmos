FROM golang:1.19-alpine AS go-builder
ARG arch=x86_64

ENV STRIDE_VERSION=v15.0.0
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


# Download stride and build
ADD https://github.com/Stride-Labs/stride/archive/refs/tags/${STRIDE_VERSION}.tar.gz ${STRIDE_VERSION}.tar.gz
RUN tar -xzf ${STRIDE_VERSION}.tar.gz && \
    cd stride-${STRIDE_VERSION#v} && \
    LEDGER_ENABLED=false BUILD_TAGS="muslc badgerdb" LDFLAGS="-linkmode=external -extldflags \"-L/code/mimalloc/build -lmimalloc -Wl,-z,muldefs -static\"" make install VERSION=${STRIDE_VERSION#v}

# Stage 2: Create minimal runtime image
FROM alpine:3

ENV DAEMON_NAME="strided"
ENV DAEMON_HOME="/stride/.stride"

RUN apk add --no-cache lz4 tar gettext && \
    addgroup -g 1211 stride && \
    adduser -G stride -u 1210 -D -h /stride stride && \
    mkdir -p /stride/.stride/config /stride/.stride/data && \
    chown stride:stride -R /stride


COPY ./config /stride/config-sample
COPY ./entrypoint.sh /stride

RUN chown stride:stride /stride/entrypoint.sh && \
    chmod +x /stride/entrypoint.sh

USER stride
WORKDIR /stride

COPY --from=go-builder /go/bin/strided /usr/local/bin/strided

# rest, grpc, p2p, rpc
EXPOSE 1317 9090 26656 26657

CMD ["sh", "-c", "/stride/entrypoint.sh"] 
