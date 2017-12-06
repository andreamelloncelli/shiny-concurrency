#!/bin/bash

echo -e "\tcat $0"
echo
exit 1

~/shiny-concurrency/proxyrec playback --target 'http://ec2-52-201-221-45.compute-1.amazonaws.com:3838/shinyTest/'  --outdir ./output_canc --concurrency 1 --duration '30sec' ../../tests/3_json/app-recording.txt


