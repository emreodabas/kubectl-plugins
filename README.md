
# kubectl-plugins
---
# `Kubectl Bulk Plugin`

This plugin useful for Bulk operations.

You can easily do bulk operations on all resource types like deployments, services, pods etc.
`Bulk plugin` has 5 main abilities for now :-)
 
  ##   **`bulk get`**  
 `bulk .. get` is a easy way to get selected fields's values for given resource types. 
 `bulk .. get` is automatically get resources name, you don't need to add for all command 
 !!Warning!! `bulk .. get` create a temporary file in path for performance.  
 
  <details>
  <summary><b>Usage</b></summary>
 <p>
  
  ``` 
   # get fields' values for given resource type
   kubectl bulk <resourceType> [<parameters>] get [<fields>]
  ``` 
   </p>
 </details> 
 <details>
   <summary><b>Sample</b></summary>
 <p>
  
   ``` 
 $ kubectl bulk hpa get minReplicas maxReplicas  
  minReplicas maxReplicas fields are getting
    name: podinfo
    maxReplicas: 10
    minReplicas: 2
    name: sample-metrics-app-hpa
    maxReplicas: 10
    minReplicas: 2
    
 $ kubectl bulk service get file json
 All definitions will be written in file.json
 
  ```
  </p>
 </details> 
 
 ##   **`bulk list`**  
`bulk .. list` is just give you easy way for getting all resource definitions in yaml or json.
`bulk .. list` is also default mode for `Bulk plugin`

 <details>
 <summary><b>Usage</b></summary>
<p>
 
 ``` 
  # list all resource definitions in yaml (default format) format 
  kubectl bulk <resourceType> [<parameters>]
  # list all resource definitions in json format  
  kubectl bulk <resourceType> [<parameters>] list json
  # list all resource definitions in to a file with json format  
  kubectl bulk <resourceType> [<parameters>] list filename json  
 ``` 
  </p>
</details> 
<details>
  <summary><b>Sample</b></summary>
<p>
 
  ``` 
$ kubectl bulk deploy -n test 
apiVersion: v1
items:
- apiVersion: extensions/v1beta1
  kind: Deployment
  name: sample-app
  ...
apiVersion: v1
items:
- apiVersion: extensions/v1beta1
  kind: Deployment
  name: another-sample-app
...
 
$ kubectl bulk service list file json
All definitions will be written in file.json

 ```
 </p>
</details> 

 ##   **`bulk create`**  
`bulk .. create` is an easy way for creating new resource from your exist resources.
`bulk .. create` is get your resource definitions and change metadata fields (name,namespaces) as you defined then create the new resources.
 !!Warning!! If that parameter not found (with/out value) than nothing will be changed/created. Standard not created error will be throwed.
  
 <details>
 <summary><b>Usage</b></summary>
<p>
 
 ``` 
# get all definitions and create resources with definitions that parameterName fields changed has oldValue with newValue
  kubectl bulk <resourceType>[<parameters>] create parameterName oldValue newValue
# get all definitions and create resources with definitions that parameterName fields removed and added with newValue
  kubectl bulk <resourceType>[<parameters>] create parameterName newValue  
 ``` 
  </p>
</details> 
<details>
  <summary><b>Sample</b></summary>
<p>
 
  ``` 
$ kubectl bulk deploy -n test create namespace test staging 
creating new resource with changing namespace: test to namespace: staging for all  deploy
deployment.extensions/sample-app created
deployment.extensions/another-sample-app created

$ kubectl bulk service create name service1 service2


 ```
 </p>
</details> 

 ##   **`bulk update`**  
`bulk .. update` is an easy way for updating bulk resource definitions.
`bulk .. update` is get your resource definitions and change any fields as you defined then update resource definitions.
 !!Warning!! If that parameter not found (with/out value) than nothing will be changed/updated. Standard not updated error will be throwed.

 <details>
 <summary><b>Usage</b></summary>
<p>
 
 ``` 
 # get all definitions and update resources with definitions that parameterName fields changed has oldValue with newValue
  kubectl bulk <resourceType>[<parameters>] update parameterName oldValue newValue
# get all definitions and update resources with definitions that parameterName fields removed and added with newValue
  kubectl bulk <resourceType>[<parameters>] update parameterName newValue  
 ``` 
  </p>
</details> 
<details>
  <summary><b>Sample</b></summary>
<p>
 
  ``` 
# Update all deploys image value in test namespace which image version was v1   
$ kubectl bulk deploy -n test update image v1 v2 
updating resource with changing image: v1 to image: v2 for all  deploy -n test
deployment.extensions/deploy-1 replaced
deployment.extensions/deploy-2 replaced
deployment.extensions/deploy-3 replaced
...
# Update all deploys image value in test namespace with v4
$ kubectl bulk deploy -n test update image v4 
updating resource with image: v5 for all  deploy 
deployment.extensions/deploy-1 replaced
deployment.extensions/deploy-2 replaced
deployment.extensions/deploy-3 replaced

 ```
 </p>
</details> 

 ##   **`bulk delete`**  
`bulk .. delete` is easy way to bulk delete resources or fields.

 <details>
 <summary><b>Usage</b></summary>
<p>
 
 ``` 
  # delete resources that in requested resource types 
  kubectl bulk <resourceType> [<parameters>] delete
  # delete fields of resources that in requested resource types  
  kubectl bulk <resourceType> [<parameters>] delete <fields>
  
 ``` 
  </p>
</details> 
<details>
  <summary><b>Sample</b></summary>
<p>
 
  ``` 
$ kubectl bulk service -n test delete
 service/svc-1 deleted
 service/svc-2 deleted
 ...
$ kubectl bulk deploy delete label1
deployment.extensions/deploy-1 replaced
deployment.extensions/deploy-2 replaced

 ```
 </p>
</details> 

 ##   **`bulk rollout`**  
`bulk .. rollout` is just give you an easy way to bulk rollout processes.   
`bulk .. rollout` gives you all rollout features that history|pause|resume|status|undo    
!!Reminder!! Rollout feature could be used only these resource types -> deployments|daemonsets|statefulsets

 <details>
 <summary><b>Usage</b></summary>
<p>
 
 ``` 
  # do rollout for all resources that requested 
  kubectl bulk <resourceType> [<parameters>] rollout history|pause|resume|status|undo <rollout parameters>
 ``` 
  </p>
</details> 
<details>
  <summary><b>Sample</b></summary>
<p>
 
  ``` 
$ kubectl bulk deploy -n test rollout undo
 'deploy's are being rollout undo
 deployment.extensions/deploy-1
deployment.extensions/deploy-2
$  kubectl bulk deploy -n test rollout history
deployment.extensions/deploy-1 
REVISION  CHANGE-CAUSE
1         <none>

deployment.extensions/deploy-2 
REVISION  CHANGE-CAUSE
1         <none>
2         <none>

 ```
 </p>
</details> 
 

# Installation 


## Linux

 `Bulk plugin` is a Bash script, it would be work in any POSIX environment that has Bash installed. 
 sed|grep|awk are prerequisite commands for `Bulk plugin`

``` bash

sudo git clone https://github.com/emreodabas/kubectl-plugins /opt/kubectl-plugins
sudo ln -s /opt/kubectl-plugins/kubectl-bulk /usr/local/bin/kubectl-bulk

```
