# kubectl-plugins

1-> Kubectl Bulk Plugin

This plugin useful for Bulk operations 
You can easily do bulk operations on resource type like deployments, services, pods etc.


USAGE:
  kubectl bulk [ResourceType][<parameters>] create parameter oldValue newValue          : get all resources with given parameters and create new resource with given parameters
  kubectl bulk [ResourceType][<parameters>] update parameter oldValue newValue          :  get all resources with given parameters and update resources with given parameters
  kubectl bulk [ResourceType][<parameters>] add parameter value                         : get all and add defined parameter with value
  kubectl bulk [ResourceType][<parameters>] delete parameter value                      : get all and delete defined parameter with given value

 
 Usage 
  
 $ kubectl bulk deployment -n development copy namespace deployment test
 
 $ 
