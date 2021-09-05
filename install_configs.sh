#!/usr/bin/env bash

set -eux;

cd "${0%/*}";
cd lcfg;
cargo run --release -- ../data;
