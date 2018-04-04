#!/bin/sh
set -e

OPTIONs=`getopt -long username:,password:,hostname:,port:,path: -- "$@"`
eval set --"$OPTIONS"

usage() {
    echo "`basename "$0"` options..."
}

PORT=554
while true; do
    case "$1" in
        --username )
            USERNAME="$2"
            shift 2
            ;;
        --password )
            PASSWORD="$2"
            shift 2
            ;;
        --hostname )
            HOSTNAME="$2"
            shift 2
            ;;
        --port )
            PORT="$2"
            shift 2
            ;;
        --path )
            PATH="$2"
            shift 2
            ;;
        --) shift; break;;
        *) usage; break;;
    esac
done
AUTH_PART=
if [ $USERNAME && $PASSWORD ]; then
    AUTH_PART=$USERNAME:$PASSWORD@
fi

ffmpeg -i rtsp://$AUTH_PART$HOSTNAME:$PORT/$PATH \
       -c copy \
       -f segment \
       -segment_time 900 \
       -segment_atclocktime 1 \
       -strftime 1 "%Y-%m-%d_%H-%M-%S.mp4"
