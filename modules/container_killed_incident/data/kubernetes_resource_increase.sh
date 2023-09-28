

#!/bin/bash



# Define the Kubernetes deployment name and the resource to increase (e.g. cpu or memory)

DEPLOYMENT=${DEPLOYMENT_NAME}

RESOURCE=${RESOURCE_NAME}



# Get the current resource allocation for the deployment

CURRENT_LIMIT=$(kubectl get deployment $DEPLOYMENT -o=jsonpath='{.spec.template.spec.containers[0].resources.limits.'$RESOURCE'}')



# Calculate the new resource limit as a percentage increase

NEW_LIMIT=$(echo "$CURRENT_LIMIT * 1.2" | bc)



# Define the new resource limit as a Kubernetes resource quantity

NEW_RESOURCE_LIMIT=${NEW_LIMIT%.*}Ki



# Update the deployment with the new resource limit

kubectl patch deployment $DEPLOYMENT --patch '{"spec": {"template": {"spec": {"containers": [{"name": "'$DEPLOYMENT'", "resources": {"limits": {"'$RESOURCE'": "'$NEW_RESOURCE_LIMIT'"}}}]}}}}'