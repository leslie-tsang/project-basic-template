#!/usr/bin/env sh

set -${ENTRYPOINT_MODE:-e}

# =======================================
# Linux basic extension module
# =======================================
__env_init() {
    apk add bash
    apk add git make

    #
    apk cache clean
}

# =======================================
# Entry
# =======================================
case_opt=$1

case ${case_opt} in
__env_init)
    shift && __env_init "${@}"
    ;;
*)
    eval "${@}"
esac
