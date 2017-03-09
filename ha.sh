#!/bin/bash

# GLOBAL VARIABLES
MODE=$1
PU_PATH=/opt/nimsoft/bin/pu
LOGIN=administrator
PASSWORD=Descartes2016
FAILED_PATTERN="failed"

# puCommand function
function puCommand {
    OUTPUT="$($PU_PATH -u $LOGIN -p $PASSWORD $1 $2 $3)"
    case "$OUTPUT" in 
        *"$FAILED_PATTERN"* ) local rc=0;;
        * ) local rc=1;;
    esac
}

# Function queue_active / queue_disabling ??

# PROBE ACTIVATE
function probe_activate {
    local result=$(puCommand controller probe_activate $1)
}

# PROBE DISABLING
function probe_disabling {
    local result=$(puCommand controller probe_deactivate $1)
}

# PROBE ARRAY ( All probes to foreach )
probesArray=(
    'net_connect' 
    'wasp' 
    'automated_deployment_engine'
    'data_engine' 
    'alarm_enrichment' 
    'discovery_server' 
    'nas' 
    'cm_data_import' 
    'ace' 
    'ppm'
    'fault_correlation_engine'
    'dirscan'
    'processes'
    'maintenance_mode' 
    'mon_config_service' 
    'mpse' 
    'nis_server' 
    'relationship_services' 
    'sla_engine' 
    'topology_agent' 
    'trellis' 
    'udm_manager'
    'cdm'
    'baseline_engine'
)

echo "Activated mode is $MODE"

# FOREACH
for probeName in "${probesArray[@]}"; do
    if [ MODE='actif' ]; then
        returncode=$(probe_activate $probeName)
    else 
        returncode=$(probe_disabling $probeName) 
    fi

    # If failed ?
    if [ returncode=1 ]; then 
        echo "=> Callback for $probeName success"
    else 
        echo "=> Callback for $probeName failed"
    fi
done
