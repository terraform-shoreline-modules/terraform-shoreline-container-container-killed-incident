resource "shoreline_notebook" "container_killed_incident" {
  name       = "container_killed_incident"
  data       = file("${path.module}/data/container_killed_incident.json")
  depends_on = [shoreline_action.invoke_container_diagnose,shoreline_action.invoke_get_pod_info,shoreline_action.invoke_get_pod_logs,shoreline_action.invoke_kubernetes_resource_increase]
}

resource "shoreline_file" "container_diagnose" {
  name             = "container_diagnose"
  input_file       = "${path.module}/data/container_diagnose.sh"
  md5              = filemd5("${path.module}/data/container_diagnose.sh")
  description      = "Resource constraints: The underlying host may have run out of resources like memory or CPU, causing the container to be killed."
  destination_path = "/agent/scripts/container_diagnose.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "get_pod_info" {
  name             = "get_pod_info"
  input_file       = "${path.module}/data/get_pod_info.sh"
  md5              = filemd5("${path.module}/data/get_pod_info.sh")
  description      = "Configuration errors: Incorrect configuration of the container or underlying software can cause issues that lead to it being killed."
  destination_path = "/agent/scripts/get_pod_info.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "get_pod_logs" {
  name             = "get_pod_logs"
  input_file       = "${path.module}/data/get_pod_logs.sh"
  md5              = filemd5("${path.module}/data/get_pod_logs.sh")
  description      = "Check the container logs to identify the cause of the container being killed. This may help identify if there is an issue with resource allocation or any other configuration issue."
  destination_path = "/agent/scripts/get_pod_logs.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "kubernetes_resource_increase" {
  name             = "kubernetes_resource_increase"
  input_file       = "${path.module}/data/kubernetes_resource_increase.sh"
  md5              = filemd5("${path.module}/data/kubernetes_resource_increase.sh")
  description      = "Increase the resource allocation for the container or the host machine if the issue is related"
  destination_path = "/agent/scripts/kubernetes_resource_increase.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_container_diagnose" {
  name        = "invoke_container_diagnose"
  description = "Resource constraints: The underlying host may have run out of resources like memory or CPU, causing the container to be killed."
  command     = "`chmod +x /agent/scripts/container_diagnose.sh && /agent/scripts/container_diagnose.sh`"
  params      = ["POD_NAME","NAMESPACE"]
  file_deps   = ["container_diagnose"]
  enabled     = true
  depends_on  = [shoreline_file.container_diagnose]
}

resource "shoreline_action" "invoke_get_pod_info" {
  name        = "invoke_get_pod_info"
  description = "Configuration errors: Incorrect configuration of the container or underlying software can cause issues that lead to it being killed."
  command     = "`chmod +x /agent/scripts/get_pod_info.sh && /agent/scripts/get_pod_info.sh`"
  params      = ["POD_NAME","NAMESPACE","CONTAINER_NAME"]
  file_deps   = ["get_pod_info"]
  enabled     = true
  depends_on  = [shoreline_file.get_pod_info]
}

resource "shoreline_action" "invoke_get_pod_logs" {
  name        = "invoke_get_pod_logs"
  description = "Check the container logs to identify the cause of the container being killed. This may help identify if there is an issue with resource allocation or any other configuration issue."
  command     = "`chmod +x /agent/scripts/get_pod_logs.sh && /agent/scripts/get_pod_logs.sh`"
  params      = ["POD_NAME","NAMESPACE"]
  file_deps   = ["get_pod_logs"]
  enabled     = true
  depends_on  = [shoreline_file.get_pod_logs]
}

resource "shoreline_action" "invoke_kubernetes_resource_increase" {
  name        = "invoke_kubernetes_resource_increase"
  description = "Increase the resource allocation for the container or the host machine if the issue is related"
  command     = "`chmod +x /agent/scripts/kubernetes_resource_increase.sh && /agent/scripts/kubernetes_resource_increase.sh`"
  params      = ["RESOURCE_NAME","DEPLOYMENT_NAME"]
  file_deps   = ["kubernetes_resource_increase"]
  enabled     = true
  depends_on  = [shoreline_file.kubernetes_resource_increase]
}

