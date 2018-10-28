# kubectl-plugins

## `Kubectl Bulk Plugin`

This plugin useful for Bulk operations.

You can easily do bulk operations on all resource types like deployments, services, pods etc.
`Bulk plugin` has 5 main abilities for now :-)
 - **`create`**
 - **`update`**
 - **`add`**
 - **`delete`**

### Usage 

```
   kubectl bulk <resourceType> [<parameters>]                                             : get all in the yaml
   kubectl bulk <resourceType> [<parameters>] create parameter oldValue newValue          : get all and copy defined parameter's value with given value
   kubectl bulk <resourceType> [<parameters>] update parameter oldValue newValue          : get all and copy defined parameter's value with given value
   kubectl bulk <resourceType> [<parameters>] add parameter value                         : get all and add defined parameter with value
   kubectl bulk <resourceType> [<parameters>] delete parameter value                      : get all and delete defined parameter with given value                

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
