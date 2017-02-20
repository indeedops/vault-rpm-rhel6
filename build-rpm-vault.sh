#!/bin/bash
#

VERSION=${1:-"0.6.5"}
ARCH=x86_64
NAME=vault

case "${ARCH}" in
    i386)
        ZIP="${NAME}_${VERSION}_linux_386.zip"
        ;;
    x86_64)
        ZIP="${NAME}_${VERSION}_linux_amd64.zip"
        ;;
    *)
        echo $"Unknown architecture ${ARCH}" >&2
        exit 1
        ;;
esac

URL="https://releases.hashicorp.com/vault/${VERSION}/${ZIP}"
echo $"Creating ${NAME} ${ARCH} RPM build file version ${VERSION}"

# fetching vault
curl -1 -k -L -o $ZIP $URL || {
    echo $"URL or version not found!" >&2
    exit 1
}

# clear target folder
rm -rf target/*

# create target structure
mkdir -p target/usr/local/bin/

# unzip
unzip -qq ${ZIP} -d target/usr/local/bin/
rm ${ZIP}

# create rpm
fpm -s dir \
    -t rpm \
    -f \
    -C target \
    -n vault \
    -v ${VERSION} \
    -p target \
    --rpm-ignore-iteration-in-dependencies \
    --description "Vault RPM package for RedHat Enterprise Linux 6" \
    --url "https://vaultproject.io" \
    usr

rm -rf target/usr
