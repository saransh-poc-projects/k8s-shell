# k8s-shell
shell scripts to automate kubernetes validation and ops processes

podCurl.sh Explanation:

1. Set the namespace_file variable to the path of the JSON file containing the namespace name.
2. Set the json_file variable to the path of the JSON file containing the URLs.
3. Set the output_file variable to the path of the CSV file to be generated.
4. Set the timestamp variable to the current date and time in the format of YYYY-MM-DD_HH:MM:SS.
5. Add the timestamp variable to the echo command that creates the header row for the output file, so that the Date and Time columns are added to the file.
6. Use the jq command to extract the namespace name from the JSON file.
7. Create a header row for the output file with the column names: Namespace, Pod Name, Pass Count, and Fail Count.
8. Use a for loop to iterate through the pods in the specified namespace. The kubectl get pods command is used to list the pods in the namespace. The awk command is used to extract the name of each pod. The tail command is used to remove the first line of output (which contains the column headers).
9. For each pod, print a message indicating that curl commands are being executed in that pod.
10. Use a nested for loop to iterate through the URLs in the JSON file.
11. Use the kubectl exec command to execute the curl command inside the current pod. The -it options are used to start an interactive shell session in the pod. The -- option is used to separate the kubectl exec command from the command to be run in the pod. The -s option is used to suppress any output from curl except for the response code. The -o /dev/null option is used to discard the response body. The -w option is used to format the output so that only the HTTP response code is returned.
12. Check if the response code starts with a 2 or 4 (i.e., a successful response). If so, print a success message and increment the pass_count variable. Otherwise, print a failure message and increment the fail_count variable.
13. Add the timestamp variable and namespace variable to the echo command that writes the results to the output file, so that the Date, Time, Namespace, Pod Name, Pass Count, and Fail Count columns are added to the file.
