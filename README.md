
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Container killed incident
---

The Container killed incident occurs when a container is terminated unexpectedly or killed due to various reasons such as insufficient resources, hardware issues, or software bugs. This incident can lead to service disruption or outage, impacting the availability and performance of the application or system running in the container. The incident requires immediate investigation and resolution to restore the service to its normal state.

### Parameters
```shell
export NAMESPACE="PLACEHOLDER"

export POD_NAME="PLACEHOLDER"

export CONTAINER_NAME="PLACEHOLDER"

export NODE_NAME="PLACEHOLDER"

export DEPLOYMENT_NAME="PLACEHOLDER"

export RESOURCE_NAME="PLACEHOLDER"
```

## Debug

### Check if the container is running
```shell
kubectl get pods -n ${NAMESPACE} | grep ${POD_NAME}
```

### Check the logs of the container
```shell
kubectl logs -n ${NAMESPACE} ${POD_NAME} -c ${CONTAINER_NAME}
```

### Check the status of the container
```shell
kubectl describe pod -n ${NAMESPACE} ${POD_NAME}
```

### Check the events related to the pod
```shell
kubectl get events -n ${NAMESPACE} --field-selector involvedObject.name=${POD_NAME}
```

### Check the resource usage of the container
```shell
kubectl top pod -n ${NAMESPACE} ${POD_NAME}
```

### Check the Kubernetes events related to the node
```shell
kubectl get events --field-selector involvedObject.kind=Node --field-selector involvedObject.name=${NODE_NAME}
```

### Check the Kubernetes node status
```shell
kubectl describe node ${NODE_NAME}
```

### Resource constraints: The underlying host may have run out of resources like memory or CPU, causing the container to be killed.
```shell


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


```

### Configuration errors: Incorrect configuration of the container or underlying software can cause issues that lead to it being killed.
```shell
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


```

## Repair

### Check the container logs to identify the cause of the container being killed. This may help identify if there is an issue with resource allocation or any other configuration issue.
```shell


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


```

### Increase the resource allocation for the container or the host machine if the issue is related
```shell


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


```