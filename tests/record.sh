#!/bin/bash

echo -e "\tcat $0"
echo
exit 1

~/shiny-concurrency/proxyrec record -t 'http://ec2-52-201-221-45.compute-1.amazonaws.com:3838/shinyTest/' > app-recording.txt



