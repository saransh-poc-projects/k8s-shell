#!/bin/bash

# function to scale-up/scale-down deployment
autoscaler(){
    input_file=$1
    execute_scale_up=$2
    execute_scale_down=$3  
    #echo $input_file
    clusters=$(jq 'keys | .[]' ${input_file})
    #echo $clusters
    for i in $clusters
    do
        echo "Cluster Name: $i"
        envs=$(jq '.'"$clusters"' | keys[]' ${input_file})
        for j in $envs
        do
            echo "Environment Name: $j"
            # create output files to store scaling commands
            scaleUp_output_file="ScaleUp_${j}.sh"
            scaleDown_output_file="ScaleDown_${j}.sh"
            # read values for each namespace from json input
            namespace_data=$(jq '.'"$clusters"'.'"$j" ${input_file})
            namespace_name=$(echo $namespace_data | jq -r '.namespace')
            echo "Namespace: $namespace_name"
            scaleUpReplica=$(echo $namespace_data | jq -r '.max_replicas')      
            scaleDownReplica=$(echo $namespace_data | jq -r '.min_replicas')    
            #echo $namespace_data
            if [[$execute_scale_up]]; then
                for deploy in $(kubectl get deploy -n $namespace_name | awk '{print $1}' | tail -n +2)
                do
                    echo "kubectl scale $deploy --replicas=$scaleUpReplica -n $namespace_name" >> $scaleUp_output_file
                done
                chmod +x "$scaleUp_output_file"
                echo "Executing Scale Up Action for deployments in namespace $namespace_name"
                echo "Executing: $scaleUp_output_file ..."
                #echo $scaleUp_output_file
                ./"$scaleUp_output_file"
            elif [[$execute_scale_down]]; then            
                for deploy in $(kubectl get deploy -n $namespace_name | awk '{print $1}' | tail -n +2)
                do
                    echo "kubectl scale $deploy --replicas=$scaleDownReplica -n $namespace_name" >> $scaleDown_output_file
                done
                chmod +x "$scaleDown_output_file"
                echo "Executing Scale Down Action for deployments in namespace $namespace_name"
                echo "Executing: $scaleDown_output_file ..."
                #echo $scaleDown_output_file
                ./"$scaleDown_output_file"
            else
                echo "No scaling action enabled $namespace_name"
            fi  
        done    
    done
}
