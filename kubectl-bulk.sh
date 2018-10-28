#!/usr/bin/env bash

[[ -n $DEBUG ]] && set -x

set -eou pipefail
IFS=$'\n\t'

SELF_CMD="$0"

DEBUG=false



ACTION_P1="";
ACTION_P2="";
ACTION_P3="";
CMD="";
GET_CMD="";
CH_CMD="";
RESOURCE_TYPE="";

 loginfo(){
   if [[ $DEBUG == true ]]; then
    echo $1;
    fi
 }

usage() {

if [ -n "$1" ] ; then
    echo $1;
fi
 cat <<"EOF"
USAGE:
  kubectl bulk [resourceType][<parameters>]                                             : get all in the yaml
  kubectl bulk [resourceType][<parameters>] get filename json|yaml                      : get all descriptions in a file with given type (yaml is default)
  kubectl bulk [resourceType][<parameters>] create parameter oldValue newValue          : get all and copy defined parameter's value with given value
  kubectl bulk [resourceType][<parameters>] update parameter oldValue newValue          : get all and copy defined parameter's value with given value
  kubectl bulk [resourceType][<parameters>] add parameter value                         : get all and add defined parameter with value
  kubectl bulk [resourceType][<parameters>] delete parameter value                      : get all and delete defined parameter with given value
  kubectl bulk [resourceType][<parameters>] delete                                     : get all and delete all resources with given resource type
EOF

}



get() {
 CMD_DETAIL="-o yaml";
 if [[ "$ACTION_P2" != "" ]];then
     CMD_DETAIL="-o ${ACTION_P2} > ./${ACTION_P1}.${ACTION_P2}";

 elif [[ "$ACTION_P1" != "" ]];then
     CMD_DETAIL="${CMD_DETAIL} > ${ACTION_P1}.yaml";
 fi
loginfo "kubectl get ${GET_CMD} ${CMD_DETAIL}";
 eval "kubectl get ${GET_CMD} ${CMD_DETAIL}";
}

create() {
 echo "creating new resource with changing $ACTION_P1: $ACTION_P2 to $ACTION_P1: $ACTION_P3 for all $GET_CMD";
       loginfo "kubectl get ${GET_CMD} -o yaml | sed 's/$ACTION_P1: $ACTION_P2/$ACTION_P1: $ACTION_P3/' | kubectl create -f - ";
        case "$RESOURCE_TYPE" in  "svc"|"service")
            echo "!!!WARNING!!! CLUSTERIP and NODEPORT fields are REMOVED while creating new one";
            eval "kubectl get ${GET_CMD} -o yaml | sed 's/$ACTION_P1: $ACTION_P2/$ACTION_P1: $ACTION_P3/' | sed '/clusterIP:/d' |  sed '/nodePort:/d' | kubectl create -f - ";
        ;;
        *)
            eval "kubectl get ${GET_CMD} -o yaml | sed 's/$ACTION_P1: $ACTION_P2/$ACTION_P1: $ACTION_P3/' | kubectl create -f - ";
        esac
}

update() {
  echo "updating new resource with changing $ACTION_P1: $ACTION_P2 to $ACTION_P1: $ACTION_P3 for all $GET_CMD";
       loginfo "kubectl get ${GET_CMD} -o yaml | sed 's/$ACTION_P1: $ACTION_P2/$ACTION_P1: $ACTION_P3/' | kubectl replace -f - ";
       eval "kubectl get ${GET_CMD} -o yaml | sed 's/$ACTION_P1: $ACTION_P2/$ACTION_P1: $ACTION_P3/' | kubectl replace -f - ";
}

add() {
## it seems not possible for now
            echo "adding $ACTION_P1: $ACTION_P2 for all $GET_CMD";
}

delete() {
CMD_DETAIL="";
 if [[ "$ACTION_P2" != "" ]];then
     CMD_DETAIL="$ACTION_P2";
 elif [[ "$ACTION_P1" != "" ]];then
     CMD_DETAIL=""$ACTION_P1": ${CMD_DETAIL}";
 fi
 case "$CMD_DETAIL"  in ": " | "")
    loginfo "kubectl get ${GET_CMD} -o jsonpath={.items[*].metadata.name} |  xargs kubectl delete ${GET_CMD} ";
    eval "kubectl get ${GET_CMD} -o jsonpath={.items[*].metadata.name} | xargs kubectl delete ${GET_CMD} ";;
  *)
    loginfo "kubectl get ${GET_CMD} -o yaml | sed '/$CMD_DETAIL/d' | kubectl replace -f - ";
    eval "kubectl get ${GET_CMD} -o yaml | sed '/$CMD_DETAIL/d' | kubectl replace -f - ";
 esac
}

action_call() {

 if [[ $CMD  ==  "create" ]];then
      create;
    elif [[ $CMD == "update" ]];then
     update;
    elif [[ $CMD == "add" ]];then
      delete;
    elif [[ $CMD == "get" ]];then
      get;
    elif [[ $CMD == "delete" ]];then
      delete;

    fi
}

read_parameters() {

 COUNTER=1
 IS_GET=true
 CMD_INDEX=0
 RESOURCE_TYPE="$1"
         while [ $COUNTER -le "$#" ]; do
           loginfo "${@:$COUNTER:1}";

            case "${@:$COUNTER:1}" in  "get"|"create"|"update"|"add"|"delete")
                  CMD=${@:$COUNTER:1};
                  CMD_INDEX=$COUNTER;
                 IS_GET=false;
                 let COUNTER=COUNTER+1;
            esac

            loginfo $IS_GET;
             if [ $IS_GET == true ];then
                GET_CMD="$GET_CMD ${@:$COUNTER:1}"
              elif [ $IS_GET == false ];then
                CH_CMD="$CH_CMD ${@:$COUNTER:1}"
             fi
                    let COUNTER=COUNTER+1
             done
             loginfo "$GET_CMD";
             loginfo "$CH_CMD";
             loginfo $GET_CMD ;
             loginfo $CMD_INDEX;
   if [[ $CMD == "" ]];then
      get;
      # usage "command not found  "create"|"update"|"add"|"delete" "
   fi

       ACTION_P1=${@:$((CMD_INDEX+1)):1};
       ACTION_P2=${@:$((CMD_INDEX+2)):1};
       ACTION_P3=${@:$((CMD_INDEX+3)):1};
       loginfo $ACTION_P1;
       loginfo $ACTION_P2;
       loginfo $ACTION_P3;

}
main() {

    read_parameters "$@";
    action_call;

}



main "$@"