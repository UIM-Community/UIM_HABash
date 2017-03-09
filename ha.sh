#!/bin/bash

# GLOBAL VARIABLES
PU_PATH=/opt/nimsoft/bin/pu
LOGIN=
PASSWORD=
FAILED_PATTERN="failed"
rc='0'

#
# Logger function (to log message with the date)
# log $message
#
function log {
    local DATE=$(date +"%D")
    local TIME=$(date +"%T")
    echo "$DATE $TIME - $1"
}

#
# execute pu command for probe activation/deactivation
# probeCMD $probeName 
# return {1|0} - 1 for true (ok) and 0 for false (ko).
#
function probeCMD {
    OUTPUT="$($PU_PATH -u $LOGIN -p $PASSWORD controller probe_activate $1)"
    case "$OUTPUT" in 
        *"$FAILED_PATTERN"* ) rc='0';;
        * ) rc='1';;
    esac
}

#
# queueCMD $queueName 
# return {1|0} - 1 for true (ok) and 0 for false (ko).
#
function queueCMD {
    OUTPUT="$($PU_PATH -u $LOGIN -p $PASSWORD hub queue_active $1 yes)"
    case "$OUTPUT" in 
        *"$FAILED_PATTERN"* ) rc='0';;
        * ) rc='1';;
    esac
}

# Probes list to enable
probesArray=(
    'data_engine'
    'alarm_enrichment'
    'ace'
    'net_connect'
    'wasp'
    'udm_manager'
    'rsp'
    'automated_deployment_engine'
    'discovery_server'
    'cm_data_import' 
    'prediction_engine'
    'ppm'
    'dirscan'
    'nas'
    'processes'
    'qos_processor'
    'health_index'
    'maintenance_mode'
    'mon_config_service'
    'mpse'
    'nis_server'
    'relationship_services'
    'sla_engine'
    'topology_agent'
    'trellis'
    'cdm'
    'baseline_engine'
    'fault_correlation_engine'
)

# Queues name to enable
queuesArray=(
    'alarm_enrichment'
    'audit',
    'data_engine'
)

log "Starting CA UIM Bascule - Activation script"

#
# Foreach (probes and queues) call action
#
log "------------------------------------"
log "Starting activation of all probes..."
for probeName in "${probesArray[@]}"; do
    log "Preparing callback probe_activate for $probeName"
    probeCMD $probeName

    # Check return code from our function and echo result
    if [ "${rc}" -eq "1" ]; then 
        log "Callback state : success"
    else 
        log "Callback state : failed"
    fi
    log "------------------------------------"
done

# (Uncomment if you want to use queue)
<<QUEUE
log "------------------------------------"
log "Starting activation of all queues..."
for queueName in "${queuesArray[@]}"; do 
    log "Preparing callback queue_activate yes for $queueName"
    queueCMD $probeName

    # Check return code from our function and echo result
    if [ "${rc}" -eq "1" ]; then 
        log "Callback state : success"
    else 
        log "Callback state : failed"
    fi
    log "------------------------------------"
done 
QUEUE

# End the script with 0 (OK)
exit 0
