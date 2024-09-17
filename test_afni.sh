#!/usr/bin/env bash

# No atlases:
#afni/afni_make_build:AFNI_24.2.06 \

docker run \
    --mount type=bind,src=`pwd -P`,dst=/wkdir \
    --entrypoint bash \
    baxterprogers/afnitest:test \
    -c ' \
    export PATH=/wkdir/src:$PATH && \
    reface.sh \
        --ref_niigz /wkdir/INPUTS/mp2rage_robust.nii.gz \
        --out_dir /wkdir/OUTPUTS \
    '

docker run \
    --mount type=bind,src=`pwd -P`,dst=/wkdir \
    --entrypoint bash \
    baxterprogers/fsl-base:v6.0.5.2 \
    -c ' \
    export PATH=/wkdir/src:$PATH && \
    finalize.sh \
        --label_info LABEL \
        --targets_niigz /wkdir/INPUTS/real1.nii.gz /wkdir/INPUTS/real2.nii.gz /wkdir/INPUTS/imag1.nii.gz /wkdir/INPUTS/imag2.nii.gz \
        --out_dir /wkdir/OUTPUTS \
    '
