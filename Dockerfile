FROM afni/afni_make_build:AFNI_24.2.06

RUN curl -o /opt/afni/install/MNI152_2009_template_SSW.nii.gz \
    https://afni.nimh.nih.gov/pub/dist/atlases/afni_atlases_dist/MNI152_2009_template_SSW.nii.gz
