#!/bin/bash

# main script to call function to scale-up or scale-down the deployment
# to bring up all deployment pods----
# ./main.sh namespace.json scale_up     
# to bring down deployment pods----
# ./main.sh namespace.json scale_down     
json_file="$1"
action="$2"

# Include the auto_iterate function
source ./autoscaler.sh

# Call the appropriate function based on the action
case "$action" in
  "scale_down")
    autoscaler "$(cat "$json_file")" false true
    ;;
  "scale_up")
    autoscaler "$(cat "$json_file")" true false
    ;;
  *)
    echo "Invalid action. Use 'scale_down' or 'scale_up'."
    exit 1
    ;;
esac
