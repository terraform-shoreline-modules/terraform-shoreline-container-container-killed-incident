

#!/bin/bash



# Set the namespace and pod name

NAMESPACE=${NAMESPACE}

POD_NAME=${POD_NAME}



# Get the logs for the pod

POD_LOGS=$(kubectl logs -n $NAMESPACE $POD_NAME)



# Check if the pod logs contain any error messages indicating why the container was killed

if [[ $POD_LOGS == *"error"* ]] || [[ $POD_LOGS == *"killed"* ]]; then

  echo "Container logs contain errors indicating why the container was killed."

  echo "$POD_LOGS"

else

  echo "No errors found in the container logs."

fi