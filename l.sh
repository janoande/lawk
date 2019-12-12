#!/bin/bash

ls --time-style='+%s' --color=always -hl "$@" | awk -f lsformat.awk

exit
