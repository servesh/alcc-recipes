#!/bin/bash

set -e

export ALCC_CCTBX_ROOT=$(readlink -f $(dirname ${BASH_SOURCE[0]}))

source ${ALCC_CCTBX_ROOT}/utilities.sh
source ${ALCC_CCTBX_ROOT}/opt/util/fix_lib_alcf.sh
source ${ALCC_CCTBX_ROOT}/opt/site/alcf_arcticus.sh

${ALCC_CCTBX_ROOT}/update_bootstrap.sh

fix-sysversions () {
    env-activate
    if fix-sysversions-perlmutter
    then
        return 1
    fi
}

${ALCC_CCTBX_ROOT}/opt/get_mamba_linux-64.sh

load-sysenv

mk-env cray-cuda-mpich-perlmutter
if fix-sysversions
then
    return 1
fi
mk-cctbx cuda build hot update
patch-dispatcher alcf

cat > ${ALCC_CCTBX_ROOT}/activate.sh << EOF
source ${ALCC_CCTBX_ROOT}/utilities.sh
source ${ALCC_CCTBX_ROOT}/opt/site/alcf_arcticus.sh
load-sysenv
activate

export CUDA_LAUNCH_BLOCKING=1
export SIT_DATA=\${OVERWRITE_SIT_DATA:-\$NERSC_SIT_DATA}:\$SIT_DATA
export SIT_PSDM_DATA=\${OVERWRITE_SIT_PSDM_DATA:-\$NERSC_SIT_PSDM_DATA}
EOF