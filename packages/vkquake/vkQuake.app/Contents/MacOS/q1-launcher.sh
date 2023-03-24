#!/bin/bash

# setting the right directories
BASEDIR="$( cd "$(dirname "$0")" || exit; pwd )"
RESOURCESDIR="$( cd "$BASEDIR/../Resources" || exit; pwd )"
FRAMEWORKSDIR="$( cd "$BASEDIR/../Frameworks" || exit; pwd )"

BIN="$RESOURCESDIR/vkquake"

export DYLD_FALLBACK_LIBRARY_PATH="$FRAMEWORKSDIR"

QUAKEDIR="$(if [[ -e "$RESOURCESDIR/id1" ]]; then echo "$RESOURCESDIR"; else echo "$HOME/.baseq1"; fi)"

$BIN -basedir $QUAKEDIR
