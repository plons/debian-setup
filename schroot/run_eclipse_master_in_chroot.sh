#!/bin/bash
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
xhost +
schroot -c darwyn ${CURRENT_DIR}/run_eclipse_master.sh
