
# kubectl-plugins
---
## `Kubectl Bulk Plugin`

This plugin useful for Bulk operations.

You can easily do bulk operations on all resource types like deployments, services, pods etc.
`Bulk plugin` has 5 main abilities for now :-)
 
 ##   **`bulk get`**  
`bulk .. get` is just give you easy way for getting all resources yaml or json.
`bulk .. get` is also default mode for `Bulk plugin`

 <details>
 <summary><b>Usage<b></summary>
<p>
 
 ``` 
  # get all resource description in yaml (default format) format 
  kubectl bulk <resourceType> [<parameters>]
  # get all resource description in json format  
  kubectl bulk <resourceType> [<parameters>] get json
  # get all resource description in to a file with json format  
  kubectl bulk <resourceType> [<parameters>] get filename json  
 ``` 
  </p>
</details> 
<details>
  <summary><b>Sample<b></summary>
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
 
$ kubectl bulk service get file json
All descriptions will be written in file.json

 ```
 </p>
</details> 

 
###  - **`create`**  
### - **`update`**  
###  - **`delete`**  
###  - **`rollout`**   
  

### Usage 

```

  # get all descriptions in a file with given type (yaml is default)
  kubectl bulk <resourceType>[<parameters>] get filename json|yaml
  # get all and copy defined parameter's value with given value
  kubectl bulk <resourceType>[<parameters>] create parameter oldValue newValue
  # get all and copy defined parameter's value with given value
  kubectl bulk <resourceType>[<parameters>] update parameter oldValue newValue
  # get all and add defined parameter with value
  kubectl bulk <resourceType>[<parameters>] add parameter value
  # get all and delete defined parameter with given value
  kubectl bulk <resourceType>[<parameters>] delete parameter value
  # get all and delete all resources with given resource type
  kubectl bulk <resourceType>[<parameters>] delete
  # get all and rollout with given parameters
  kubectl bulk <resourceType>[<parameters>] rollout history|pause|resume|status|undo <paramaters>
``` 
### Samples

```   
 $ kubectl bulk all -n develop create namespace develop test
 
 $ kubectl bulk deploy update image app:v1 app:v2
 
 $ kubectl bulk pods delete somelabel 
 
 $ kubectl bulk hpa -n temp delete 
 
 $ kubectl bulk svc  update type NodePort LoadBalancer
 
 $ kubectl bulk pods 

```

### Installation 


### Linux

Since `Bulk plugin` are written in Bash, you should be able to install
them to any POSIX environment that has Bash installed.

``` bash

sudo git clone https://github.com/emreodabas/kubectl-plugins /opt/kubectl-plugins
sudo ln -s /opt/kubectl-plugins/kubectl-bulk /usr/local/bin/kubectl-bulk

```
