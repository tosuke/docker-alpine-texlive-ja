# Copyright (c) 2016 Kaito Udagawa
# Copyright (c) 2016-2020 3846masa
# Released under the MIT license
# https://opensource.org/licenses/MIT

FROM debian:buster-slim as base

RUN apt-get update && \
    apt-get install -y wget tar perl fontconfig fontconfig-config libfreetype6
ENV PATH /usr/local/texlive/2021/bin/$(arch)-linux:$PATH

FROM base AS install
ARG texlive_mirror=http://ftp.jaist.ac.jp/pub/CTAN/systems/texlive/tlnet

WORKDIR /tmp/install-tl-unx
RUN wget ${texlive_mirror}/install-tl-unx.tar.gz && \
    tar xvf install-tl-unx.tar.gz
COPY ./texlive.profile .
RUN cd ./install-tl-* && \
    ./install-tl \
      --repository ${texlive_mirror} \
      --profile=/tmp/install-tl-unx/texlive.profile
RUN /usr/local/texlive/2021/bin/$(arch)-linux/tlmgr install \
      collection-latexextra \
      collection-fontsrecommended \
      collection-langjapanese \
      latexmk

WORKDIR /workdir

CMD ["sh"]
