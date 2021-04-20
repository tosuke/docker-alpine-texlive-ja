# Copyright (c) 2016 Kaito Udagawa
# Copyright (c) 2016-2020 3846masa
# Released under the MIT license
# https://opensource.org/licenses/MIT

FROM debian:buster-slim as base

RUN apt-get update && \
    apt-get install -y wget tar perl fontconfig fontconfig-config libfreetype6 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* 
ENV PATH=/usr/local/texlive/2021/bin/linux:$PATH

FROM base AS install

RUN apt-get update && apt-get install -y curl

WORKDIR /tmp/install-tl-unx
RUN wget https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz && \
    tar xvf install-tl-unx.tar.gz
COPY ./texlive.profile .
RUN cd ./install-tl-* && \
    REPO=$(curl -w "%{redirect_url}" -s -o /dev/null https://mirror.ctan.org/systems/texlive/tlnet/) && \
    ./install-tl \
      --profile=/tmp/install-tl-unx/texlive.profile \
      --repository $REPO &&\
    cd /usr/local/texlive/2021 && \
    mv ./bin/* ./bin/linux
RUN tlmgr install collection-latexextra
RUN tlmgr install collection-fontsrecommended
RUN tlmgr install collection-langjapanese
RUN tlmgr install latexmk

FROM base 

COPY --from=install /usr/local/texlive /usr/local/texlive

WORKDIR /workdir

ENTRYPOINT [ "bash" ]
