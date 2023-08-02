FROM golang:1.19-alpine AS go-builder
ARG arch=x86_64

ENV STRIDE_VERSION=v12.1.0
ENV PACKAGES git cmake ca-certificates build-base curl make libc-dev bash gcc linux-headers eudev-dev python3 libusb-dev

RUN set -eux; apk add --no-cache $PACKAGES;

WORKDIR /code

# Install mimalloc
RUN git clone --depth 1 https://github.com/microsoft/mimalloc; cd mimalloc; mkdir build; cd build; cmake ..; make -j$(nproc); make install

# Download Gaia
RUN git clone https://github.com/Stride-Labs/stride
WORKDIR /code/stride
RUN git checkout ${STRIDE_VERSION}

# force it to use static lib (from above) not standard libgo_cosmwasm.so file
RUN LEDGER_ENABLED=false BUILD_TAGS="muslc badgerdb" LDFLAGS="-linkmode=external -extldflags \"-L/code/mimalloc/build -lmimalloc -Wl,-z,muldefs -static\"" make install


FROM alpine

ENV DAEMON_NAME="strided"
ENV DAEMON_HOME="/stride/.stride"

RUN apk add --no-cache lz4 tar gettext

RUN addgroup -g 1211 stride \
    && adduser -G stride -u 1210 -D -h /stride stride

COPY ./config /stride/config-sample
COPY ./entrypoint.sh /stride

RUN chown stride:stride -R /stride/config-sample
RUN chown stride:stride /stride/entrypoint.sh
RUN chmod +x /stride/entrypoint.sh

USER stride

WORKDIR /stride

RUN mkdir -p .stride/config; mkdir -p .stride/data;

COPY --from=go-builder /go/bin/strided /usr/local/bin/strided


# rest server
EXPOSE 1317
# grpc
EXPOSE 9090
# tendermint p2p
EXPOSE 26656
# tendermint rpc
EXPOSE 26657

CMD ["sh", "-c", "/stride/entrypoint.sh"]
