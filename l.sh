#!/bin/bash

SRC_DIR=$(dirname $(readlink "$0"))

ls --time-style='+%s' --color=always -hl "$@" | awk -f $SRC_DIR/lsformat.awk 

exit
