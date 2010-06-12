#!/bin/bash

TOKILL="$(ps aux | grep flash | grep chrom | onespace.sh | cut -d " " -f 2)"
kill -9 $TOKILL
