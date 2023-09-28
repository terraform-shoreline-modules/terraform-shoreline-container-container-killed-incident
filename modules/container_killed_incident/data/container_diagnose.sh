

#!/bin/bash



# Set the namespace and pod name for the container to diagnose

NAMESPACE=${NAMESPACE}

POD_NAME=${POD_NAME}



# Get the logs for the container

kubectl logs -n $NAMESPACE $POD_NAME



# Check the memory and CPU usage of the container

kubectl top pod -n $NAMESPACE $POD_NAME



# Check the system logs for any resource-related errors

kubectl logs -n $NAMESPACE $POD_NAME | grep -i "out of memory"

kubectl logs -n $NAMESPACE $POD_NAME | grep -i "cpu limit exceeded"