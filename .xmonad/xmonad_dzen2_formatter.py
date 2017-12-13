#! /usr/bin/env python3
import os
import sys

with open(os.path.expanduser('~/dzen2log.log'), 'w+') as log:
    while True:
        s = sys.stdin.readline()
        if s:
            print(s)
            log.write(s + "\n")
