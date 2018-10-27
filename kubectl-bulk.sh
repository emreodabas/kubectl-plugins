#!/usr/bin/env bash

[[ -n $DEBUG ]] && set -x

set -eou pipefail
IFS=$'\n\t'

SELF_CMD="$0"

DEBUG=false

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
  kubectl bulk [resource Type][<parameters>] get                                         : get all in the yaml
  kubectl bulk [resource Type][<parameters>] create parameter oldValue newValue          : get all and copy defined parameter's value with given value
  kubectl bulk [resource Type][<parameters>] update parameter oldValue newValue          : get all and copy defined parameter's value with given value
  kubectl bulk [resource Type][<parameters>] add parameter value                         : get all and add defined parameter with value
  kubectl bulk [resource Type][<parameters>] delete parameter value                      : get all and delete defined parameter with given value

EOF

}



main() {
 if [[ "$#" -lt 3 ]]; then
        usage ""
        exit 0
        fi
 COUNTER=1
 GET_CMD=""
 CH_CMD=""
 IS_GET=true
 CMD=""
 CMD_INDEX=0
 RESOURCE_TYPE="$1"
         while [ $COUNTER -le "$#" ]; do
           loginfo "${@:$COUNTER:1}";

            case "${@:$COUNTER:1}" in  "create"|"update"|"add"|"delete")
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
        usage "command not found  "create"|"update"|"add"|"delete" "
   fi

       CH_PARAMETER=${@:$((CMD_INDEX+1)):1};
       CH_OLD_VALUE=${@:$((CMD_INDEX+2)):1};
       CH_NEW_VALUE=${@:$((CMD_INDEX+3)):1};
       loginfo $CH_PARAMETER;
       loginfo $CH_OLD_VALUE;
       loginfo $CH_NEW_VALUE;

    if [[ $CMD  ==  "create" ]];then
       echo "creating new resource with changing $CH_PARAMETER: $CH_OLD_VALUE to $CH_PARAMETER: $CH_NEW_VALUE for all $GET_CMD";
       loginfo "kubectl get ${GET_CMD} -o yaml | sed 's/$CH_PARAMETER: $CH_OLD_VALUE/$CH_PARAMETER: $CH_NEW_VALUE/' | kubectl create -f - ";
        case "$RESOURCE_TYPE" in  "svc"|"service")
            echo "!!!WARNING!!! ClusterIp and NodePort fields are REMOVED while creating new one";
            eval "kubectl get ${GET_CMD} -o yaml | sed 's/$CH_PARAMETER: $CH_OLD_VALUE/$CH_PARAMETER: $CH_NEW_VALUE/' | sed '/clusterIP:/d' |  sed '/nodePort:/d' | kubectl create -f - ";
        ;;
        *)
            eval "kubectl get ${GET_CMD} -o yaml | sed 's/$CH_PARAMETER: $CH_OLD_VALUE/$CH_PARAMETER: $CH_NEW_VALUE/' | kubectl create -f - ";
        esac
    elif [[ $CMD == "update" ]];then
       echo "updating new resource with changing $CH_PARAMETER: $CH_OLD_VALUE to $CH_PARAMETER: $CH_NEW_VALUE for all $GET_CMD";
       loginfo "kubectl get ${GET_CMD} -o yaml | sed 's/$CH_PARAMETER: $CH_OLD_VALUE/$CH_PARAMETER: $CH_NEW_VALUE/' | kubectl replace -f - ";
       eval "kubectl get ${GET_CMD} -o yaml | sed 's/$CH_PARAMETER: $CH_OLD_VALUE/$CH_PARAMETER: $CH_NEW_VALUE/' | kubectl replace -f - ";
    elif [[ $CMD == "add" ]];then
       CH_PARAMETER=${@:$((CMD_INDEX+1)):1};
       CH_VALUE=${@:$((CMD_INDEX+2)):1};
            echo "adding $CH_PARAMETER: $CH_VALUE for all $GET_CMD";
    fi

}



main "$@"