#!/bin/sh
set -e

OPTIONS=`getopt -o a:d:t --long age:,dir:,test -- "$@"`
eval set -- "$OPTIONS"

usage() {
    echo "`basename "$0"` -d|--dir <folder containing files to purge> [-a|--age <age of files in days>]"
}

FILE_AGE=10
DELETE_CMD=-delete
while true; do
    case "$1" in
        -d | --dir )
            VIDEO_DIR="$2"
            shift 2
            ;;
        -a | --age )
            FILE_AGE="$2"
            shift 2
            ;;
        -t | --test )
            DELETE_CMD=
            shift
            ;;
        --) shift; break;;
        *) usage; break;;
    esac
done

if [ ! $VIDEO_DIR ]; then
    usage
    exit 1
fi

find $VIDEO_DIR -mtime +$FILE_AGE -type f $DELETE_CMD
