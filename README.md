# tosuke/docker-debian-slim-texlive-ja

[!Docker build](https://img.shields.io/github/workflow/status/tosuke/docker-debian-slim-texlive-ja/Docker)

> Minimal TeX Live image for Japanese based on debian slim

Forked from [Paperist/texlive-ja](https://github.com/Paperist/texlive-ja) \(under the MIT License\).

## Table of Contents

- [Install](#install)
- [Usage](#usage)
- [Contribute](#contribute)
- [License](#license)

## Install

```bash
docker pull ghcr.io/tosuke/debian-slim-texlive-ja:latest
```

## Usage

```bash
$ docker run --rm -it -v $PWD:/workdir paperist/alpine-texlive-ja
$ latexmk -C main.tex && latexmk main.tex && latexmk -c main.tex
```

## Contribute

PRs accepted.

## License

MIT © 3846masa
