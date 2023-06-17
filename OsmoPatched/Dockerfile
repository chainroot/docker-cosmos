FROM golang:1.19.3-alpine3.16 AS go-builder
ARG arch=x86_64

ENV OSMO_VERSION=v13.1.2
# See https://github.com/osmo-money/wasmvm/releases
ENV LIBWASMVM_VERSION=v1.1.1
ENV COSMOVISOR_VERSION=v1.4.0
ENV PACKAGES git cmake ca-certificates build-base curl make libc-dev bash gcc linux-headers eudev-dev python3 libusb-dev

RUN set -eux; apk add --no-cache $PACKAGES;

WORKDIR /code

# Install mimalloc
RUN git clone --depth 1 https://github.com/microsoft/mimalloc; cd mimalloc; mkdir build; cd build; cmake ..; make -j$(nproc); make install

# See https://github.com/CosmWasm/wasmvm/releases
ADD https://github.com/CosmWasm/wasmvm/releases/download/${LIBWASMVM_VERSION}/libwasmvm_muslc.aarch64.a libwasmvm_muslc.aarch64.a
ADD https://github.com/CosmWasm/wasmvm/releases/download/${LIBWASMVM_VERSION}/libwasmvm_muslc.x86_64.a libwasmvm_muslc.x86_64.a
ADD https://github.com/CosmWasm/wasmvm/releases/download/${LIBWASMVM_VERSION}/checksums.txt checksums.txt
RUN cat checksums.txt | sha256sum -c -s
# Copy the library you want to the final location that will be found by the linker flag `-lwasmvm_muslc`
RUN cp libwasmvm_muslc.`uname -m`.a /lib/libwasmvm_muslc.a

# Download Cosmovisor
RUN git clone https://github.com/cosmos/cosmos-sdk

# Download osmo
RUN git clone https://github.com/osmosis-labs/osmosis
WORKDIR /code/osmosis
RUN git checkout ${OSMO_VERSION}

# force it to use static lib (from above) not standard libgo_cosmwasm.so file
RUN LEDGER_ENABLED=false BUILD_TAGS=muslc LDFLAGS="-linkmode=external -extldflags \"-L/code/mimalloc/build -lmimalloc -Wl,-z,muldefs -static\"" make build

#Build Cosmovisor
WORKDIR /code/cosmos-sdk
#Checkout cosmovisor/version for versions before 1.4.0
RUN git checkout tools/cosmovisor/${COSMOVISOR_VERSION}
RUN make cosmovisor


FROM alpine:3.16

ENV DAEMON_NAME="osmosisd"
ENV DAEMON_HOME="/osmosis/.osmosis"

RUN apk add --no-cache lz4 tar gettext

RUN addgroup -g 1211 osmosis \
    && adduser -G osmosis -u 1210 -D -h /osmosis osmosis

COPY ./config /osmosis/config-sample
COPY ./entrypoint.sh /osmo

RUN chown osmosis:osmosis -R /osmosis/config-sample
RUN chown osmosis:osmosis /osmo/entrypoint.sh
RUN chmod +x /osmosis/entrypoint.sh

USER osmosis

WORKDIR /osmosis

RUN mkdir -p .osmosis/config; mkdir -p .osmosis/data; mkdir -p .osmosiscosmovisor/genesis/bin; mkdir -p .osmosis/cosmovisor/upgrades

COPY --from=go-builder /code/osmosis/build/osmosisd /usr/local/bin/osmosisd
COPY --from=go-builder /code/cosmos-sdk/tools/cosmovisor/cosmovisor /usr/local/bin/cosmovisor

# rest server
EXPOSE 1317
# grpc
EXPOSE 9090
# tendermint p2p
EXPOSE 26656
# tendermint rpc
EXPOSE 26657

CMD ["sh", "-c", "/osmosis/entrypoint.sh"]