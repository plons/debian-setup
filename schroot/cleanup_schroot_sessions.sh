#!/bin/bash
for session in $(ls /var/lib/schroot/session/); do schroot --end-session -c $session; done
