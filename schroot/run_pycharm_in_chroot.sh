#!/bin/bash
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
xhost +
schroot -c darwyn ${CURRENT_DIR}/run_pycharm_with_display.sh $DISPLAY
