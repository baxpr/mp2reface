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
