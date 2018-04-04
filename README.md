# serverless-cctv
Serverless implementation of a CCTV video hosting and playback system


So far, just a collection of thoughts and notes.

## Overview
POE powered IP Cameras with an on-premise server to record them continuously (segmenting the recordings into 10-15 minute chunks). Use ONVIF alerts configured on the devices for motion detection and to determine which video segments to upload.

## Recording
Use ffmpeg to continually record output from an IP camera, splitting it into 15 minute segments. This approach means no video is missed, which is what would happen if you started a new ffmpeg process per segment.

``` shell
ffmpeg -i rtsp://ip_cam -c copy -map 0 -f segment -segment_time 300 -segment_format mp4 "capture-%03d.mp4"
```
or

``` shell
ffmpeg -i rtsp://ip_cam -c copy -f segment -segment_time 900 -segment_atclocktime 1 -strftime 1 "%Y-%m-%d_%H-%M-%S.mkv"
```
https://ffmpeg.org/ffmpeg-formats.html#segment_002c-stream_005fsegment_002c-ssegment

## Motion detection
Normal motion detection using the motion app or similar, doesn't work too well for outside cameras as light changes etc. cause many false positives. OpenCV and Tensorflow based options are more accurate but require hefty GPU resources. Most cameras these days have reasonable on-board motion detection options that can be configured quite well, but these would still have many false positives, so the basic idea is to listen for these ONVIF events, then upload the associated video segment to AWS, potentially passing it through the Rekognition service to do more accurate detection and tagging. Then only send alerts for videos that have people tagged. The tags would also allow for the playback interface to group recordings (e.g. videos containing animals, multiple people etc.)

### ONVIF resources
1. node js library: https://github.com/futomi/node-onvif
2. Description of process used for zoneminder: https://altaroca.wordpress.com/2014/11/24/onvif-notifications-and-zoneminder/


## Storage
Store in S3 buckets - originals are uploaded, then passed to transcoding service to produce versions suitable for playback online. Could use lifecycle policies to move videos to glacier after a period of time.

## Playback
Some sort of web app, hosted on AWS, allowing for simple viewing of all motion events and video.
