# syntax=docker/dockerfile:experimental

# Copyright (c) 2016 Kaito Udagawa
# Copyright (c) 2016-2020 3846masa
# Released under the MIT license
# https://opensource.org/licenses/MIT

FROM debian:buster-slim as base

RUN apt-get update && \
    apt-get install -y perl fontconfig fontconfig-config libfreetype6 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* 
ENV PATH=/usr/local/texlive/latest/bin/linux:$PATH

FROM base AS install
RUN apt-get update && apt-get install -y curl wget tar gzip

WORKDIR /work
RUN curl -L https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz \
    | tar zx -C /work
COPY ./texlive.profile /work/
RUN cd ./install-tl-* && \
    REPO=$(curl -w "%{redirect_url}" -s -o /dev/null https://mirror.ctan.org/systems/texlive/tlnet/) && \
    ./install-tl \
      --profile=/work/texlive.profile \
      --repository $REPO && \
    cd /usr/local/texlive/latest && \
    ln -s $(pwd)/bin/$(arch)-linux $(pwd)/bin/linux
RUN tlmgr install latexmk

FROM base 

COPY --from=install /usr/local/texlive /usr/local/texlive

WORKDIR /workdir

ENTRYPOINT [ "bash" ]
