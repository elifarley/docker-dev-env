#!/bin/sh
set -x

curl https://sh.rustup.rs -sSf | sh -s -- -y

. $HOME/.cargo/env

rustc --version || exit

curl https://rustwasm.github.io/wasm-pack/installer/init.sh -sSf | sh && \
cargo install cargo-generate