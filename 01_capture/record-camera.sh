#!/bin/sh
set -e

OPTIONS=`getopt -long username:,password:,hostname:,port:,path:,output: -- "$@"`
eval set --"$OPTIONS"

usage() {
    echo "`basename "$0"` options..."
}

PORT=554
OUTPUT_DIR=/tmp
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
        --output )
            OUTPUT_DIR="$2"
            shift 2
            ;;
        --) shift; break;;
        *) usage; break;;
    esac
done

if [ $USERNAME ]; then
    AUTH_PART=$USERNAME:$PASSWORD@
fi

echo ffmpeg \
     -loglevel panic \
     -rtsp_transport tcp \
     -i rtsp://$AUTH_PART$HOSTNAME:$PORT/$PATH \
     -map 0:0 \
     -c:v copy \
     -an \
     -f segment \
     -reset_timestamps 1 \
     -segment_time 900 \
     -segment_atclocktime 1 \
     -strftime 1 "$OUTPUT_DIR/%Y-%m-%d_%H-%M-%S.mp4"
