FROM golang:1.19.3-alpine3.16 AS go-builder
ARG arch=x86_64

ENV TERRA_VERSION=v2.2.0
ENV CHAIN_ID=phoenix-1
# See https://github.com/terra-money/wasmvm/releases
ENV LIBWASMVM_VERSION=v1.1.1
ENV COSMOVISOR_VERSION=v1.4.0
ENV PACKAGES git cmake ca-certificates build-base curl make libc-dev bash gcc linux-headers eudev-dev python3 libusb-dev
ENV MIMALLOC_RESERVE_HUGE_OS_PAGES=1
ENV SKIP_REPO=https://raw.githubusercontent.com/skip-mev/config/main/${CHAIN_ID}/${TERRA_VERSION}


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

# Download Terra
RUN git clone https://github.com/terra-money/core/
WORKDIR /code/core
RUN git checkout ${TERRA_VERSION}

# Replace tendermint with skip-mev-tendermint
RUN MEV_TENDERMINT_VERSION="$(curl -s "${SKIP_REPO}/mev-tendermint_version.txt")" && \
go mod edit -replace github.com/tendermint/tendermint=github.com/skip-mev/mev-tendermint@$MEV_TENDERMINT_VERSION

# Check and install dependencies
RUN go mod tidy

# force it to use static lib (from above) not standard libgo_cosmwasm.so file
RUN LEDGER_ENABLED=false BUILD_TAGS=muslc LDFLAGS="-linkmode=external -extldflags \"-L/code/mimalloc/build -lmimalloc -Wl,-z,muldefs -static\"" make build

#Build Cosmovisor
WORKDIR /code/cosmos-sdk
#Checkout cosmovisor/version for versions before 1.4.0
RUN git checkout tools/cosmovisor/${COSMOVISOR_VERSION}
RUN make cosmovisor


FROM alpine:3.16

ENV DAEMON_NAME="terrad"
ENV DAEMON_HOME="/terra/.terra"

RUN apk add --no-cache lz4 tar gettext

RUN addgroup -g 1211 terra \
    && adduser -G terra -u 1210 -D -h /terra terra

COPY ./config /terra/config-sample
COPY ./entrypoint.sh /terra

RUN chown terra:terra -R /terra/config-sample
RUN chown terra:terra /terra/entrypoint.sh
RUN chmod +x /terra/entrypoint.sh

USER terra

WORKDIR /terra

RUN mkdir -p .terra/config; mkdir -p .terra/data; mkdir -p .terra/cosmovisor/genesis/bin; mkdir -p .terra/cosmovisor/upgrades

COPY --from=go-builder /code/core/build/terrad /usr/local/bin/terrad
COPY --from=go-builder /code/cosmos-sdk/tools/cosmovisor/cosmovisor /usr/local/bin/cosmovisor


# rest server
EXPOSE 1317
# grpc
EXPOSE 9090
# tendermint p2p
EXPOSE 26656
# tendermint rpc
EXPOSE 26657

CMD ["sh", "-c", "/terra/entrypoint.sh"]