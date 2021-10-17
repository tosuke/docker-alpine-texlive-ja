# syntax=docker/dockerfile:1

# Copyright (c) 2016 Kaito Udagawa
# Copyright (c) 2016-2020 3846masa
# Copyright (c) 2021 Keisuke Nitta
# Released under the MIT license
# https://opensource.org/licenses/MIT

FROM debian:buster-slim AS base

RUN apt-get update && \
    apt-get install -y perl wget xz-utils && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* 
ENV PATH=/usr/local/texlive/latest/bin/linux:$PATH

FROM --platform=$BUILDPLATFORM debian:buster-slim AS install
ARG BUILDPLATFORM
ARG TARGETPLATFORM

RUN apt-get update && \
    apt-get install -y perl curl wget xz-utils
COPY --from=base /lib /target-lib

WORKDIR /work
COPY ./copy-lib.sh /work/
RUN /work/copy-lib.sh $TARGETPLATFORM $BUILDPLATFORM

COPY ./texlive.profile /work/
COPY ./texlive-arch.sh /work/
RUN curl -L https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz | tar zx -C /work
RUN cd ./install-tl-* && \
    REPO=$(curl -w "%{redirect_url}" -s -o /dev/null https://mirror.ctan.org/systems/texlive/tlnet/) && \
    ./install-tl \
      --force-arch $(/work/texlive-arch.sh $TARGETPLATFORM) \
      --profile=/work/texlive.profile
RUN ln -sf /usr/local/texlive/latest/bin/*-linux /usr/local/texlive/latest/bin/linux

FROM base AS dist

COPY --from=install /usr/local/texlive /usr/local/texlive

RUN tlmgr install \
  latexmk \
  physics \
  siunitx
WORKDIR /work

VOLUME ["/work"]

CMD [ "bash" ]
