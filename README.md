
# kubectl-plugins
---
## `Kubectl Bulk Plugin`

This plugin useful for Bulk operations.

You can easily do bulk operations on all resource types like deployments, services, pods etc.
`Bulk plugin` has 5 main abilities for now :-)
 
 ##   **`bulk get`**  
`bulk .. get` is just give you easy way for getting all resource definitions in yaml or json.
`bulk .. get` is also default mode for `Bulk plugin`

 <details>
 <summary><b>Usage<b></summary>
<p>
 
 ``` 
  # get all resource definitions in yaml (default format) format 
  kubectl bulk <resourceType> [<parameters>]
  # get all resource definitions in json format  
  kubectl bulk <resourceType> [<parameters>] get json
  # get all resource definitions in to a file with json format  
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
All definitions will be written in file.json

 ```
 </p>
</details> 

 ##   **`bulk create`**  
`bulk .. create` is an easy way for creating new resource from your exist resources.
`bulk .. create` is get your resource definitions and change metadata fields (name,namespaces) as you defined then create the new resources.
 !!Warning!! If that parameter not found (with/out value) than nothing will be changed/created. Standard not created error will be throwed.
  
 <details>
 <summary><b>Usage<b></summary>
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
  <summary><b>Sample<b></summary>
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
 <summary><b>Usage<b></summary>
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

 ##   **`bulk delete`**  
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

 ##   **`bulk rollout`**  
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
