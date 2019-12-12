#!/bin/bash

# merge the content of the awk file into the ls script

awkfile=$(<lsformat.awk)
lsfile=$(<l.sh)
echo "${lsfile//-f lsformat.awk/\'$awkfile\'}" > $1
