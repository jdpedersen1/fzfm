#!/bin/bash

if [ -d "/tmp/copied" ]; then
    mv /tmp/copied/* .
    rm -rf /tmp/copied
else
    mkdir /tmp/copied
    cp "$@" /tmp/copied
fi

