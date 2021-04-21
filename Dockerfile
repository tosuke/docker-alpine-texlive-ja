# syntax=docker/dockerfile:experimental

# Copyright (c) 2016 Kaito Udagawa
# Copyright (c) 2016-2020 3846masa
# Released under the MIT license
# https://opensource.org/licenses/MIT

FROM debian:buster-slim AS base

RUN apt-get update && \
    apt-get install -y perl python3-pygments curl wget xz-utils libfontconfig-dev ghostscript && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* 
ENV PATH=/usr/local/texlive/latest/bin/linux:$PATH

FROM base AS install

WORKDIR /work
COPY ./texlive.profile /work/
RUN curl -L https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz \
    | tar zx -C /work && \
    cd ./install-tl-* && \
    REPO=$(curl -w "%{redirect_url}" -s -o /dev/null https://mirror.ctan.org/systems/texlive/tlnet/) && \
    ./install-tl \
      --profile=/work/texlive.profile \
      --repository $REPO && \
    cd /usr/local/texlive/latest && \
    ln -s $(pwd)/bin/$(arch)-linux $(pwd)/bin/linux && \
    cd / && rm -rf /work

FROM base

COPY --from=install /usr/local/texlive /usr/local/texlive

WORKDIR /workdir

ENTRYPOINT [ "bash" ]
