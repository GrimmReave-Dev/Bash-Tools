#!/bin/bash

md5=$(echo -n "$1" | md5sum | cut -d' ' -f1)

echo "flag{$md5}"
