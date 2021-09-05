#!/usr/bin/env bash

set -eux;

cd "${0%/*}";
./install_configs.sh;
cd lcfg;
cargo run --release -- ../data;
