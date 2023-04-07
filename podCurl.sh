#!/bin/bash

# Set variables
namespaces_file="namespaces.json"
json_file="urls.json"
output_file="results.csv"
timestamp=$(date +%Y-%m-%d_%H:%M:%S)

# Create header for output file
echo "Date,Time,Namespace,Pod Name,Pass Count,Fail Count" > $output_file

# Loop through namespaces
for namespace in $(cat $namespaces_file | jq -r '.[].namespace')
do
  echo "Executing curl commands in namespace: $namespace"
  
  # Loop through pods in namespace
  for pod in $(kubectl get pods -n $namespace | awk '{print $1}' | tail -n +2)
  do
    echo "Executing curl commands in pod: $pod"
    
    # Loop through URLs in JSON file
    for url in $(cat $json_file | jq -r '.[].url')
    do
      # Make curl request and record response
      response=$(kubectl exec -it $pod -n $namespace -- curl -s -o /dev/null -w "%{http_code}" $url)

      # Check if request was successful
      if [[ "$response" =~ ^[24] ]]; then
        echo "SUCCESS: $url returned $response"
        ((pass_count++))
      else
        echo "FAILURE: $url returned $response"
        ((fail_count++))
      fi
    done
    
    # Write results to output file
    echo "$timestamp,$namespace,$pod,$pass_count,$fail_count" >> $output_file
    
    # Reset counts for next pod
    fail_count=0
    pass_count=0
  done
done
