bash

#!/bin/bash



# Set variables

NAMESPACE=${NAMESPACE}

POD_NAME=${POD_NAME}

CONTAINER_NAME=${CONTAINER_NAME}



# Get logs for the container

echo "=== Container logs ==="

kubectl logs -n $NAMESPACE $POD_NAME $CONTAINER_NAME



# Get container status

echo "=== Container status ==="

kubectl describe pod -n $NAMESPACE $POD_NAME | grep -A 2 $CONTAINER_NAME



# Get pod events

echo "=== Pod events ==="

kubectl get events -n $NAMESPACE --field-selector involvedObject.name=$POD_NAME



# Check for misconfigured resources

echo "=== Resources ==="

kubectl describe pod -n $NAMESPACE $POD_NAME | grep -A 5 "Limits" | grep -v "Limits" | grep -v "\-\-"



# Check for misconfigured environment variables

echo "=== Environment variables ==="

kubectl exec -n $NAMESPACE $POD_NAME -c $CONTAINER_NAME -- printenv



# Check for misconfigured volumes

echo "=== Volumes ==="

kubectl describe pod -n $NAMESPACE $POD_NAME | grep -A 2 "Volumes:"