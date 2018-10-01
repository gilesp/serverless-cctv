#!/bin/sh
set -e

usage() {
    echo "`basename "$0"` -d|--dir <folder containing video files to upload>"
}

check_dependencies() {
    command -v aws >/dev/null 2>&1 || { echo >&2 "I require aws cli tools but they're not installed.  Aborting."; exit 1; }
}

upload_to_s3() {
    echo "Uploading to s3 (NOT IMPLEMENTED)"
}

delete_file() {
    echo "Deleting file (NOT IMPLEMENTED)"
}

check_dependencies

OPTIONS=`getopt -o d: --long dir: -- "$@"`
eval set -- "$OPTIONS"

while true; do
    case "$1" in
	-d | --dir )
	    VIDEO_DIR="$2"
	    shift 2
	    ;;
	--) shift; break;;
	*) usage; break;;
    esac
done

if [ ! $VIDEO_DIR ]; then
    usage
    exit 1
fi

# loop over files in directory
# for each one, upload to s3.
# then delete
for f in $VIDEO_DIR/*.mp4
do
    [ -f "$f" ] || break
    echo "Processing $f file..."
    upload_to_s3 $f && \
	delete_file $f
done

