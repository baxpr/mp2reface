#!/usr/bin/env bash
#
# Pipeline for refacing an mp2rage series using AFNI.

# Initialize defaults
export label_info=
export ref_niigz=/INPUTS/robust.nii.gz
export targets_niigz="/INPUTS/e1real.nii.gz /INPUTS/e1imag.nii.gz"
export out_dir=/OUTPUTS

# Parse options
while [[ $# -gt 0 ]]; do
	key="${1}"
	case $key in
		--label_info)
			export label_info="${2}"; shift; shift ;;
		--ref_niigz)
			export ref_niigz="${2}"; shift; shift ;;
		--targets_niigz)
            next="$2"
            while ! [[ "$next" =~ -.* ]] && [[ $# > 1 ]]; do
                targets_niigz+=("$next")
                shift
                next="$2"
            done
            shift ;;
		--out_dir)
			export out_dir="${2}"; shift; shift ;;
		*)
			echo Unknown input "${1}"; shift ;;
	esac
done

# Reface
@afni_refacer_run \
	-input "${ref_niigz}" \
	-mode_all \
	-prefix "${out_dir}"/img

# Apply face mask to target images
# FIXME we are here

# Make PDF
thedate=$(date)
cd "${out_dir}"/img_QC
for piece in deface face face_plus reface reface_plus ; do

	montage \
		-mode concatenate img.${piece}.???.png \
		-tile 1x -trim -quality 100 -background white -gravity center -resize 1200x1400 \
		-border 20 -bordercolor white ${piece}.png

	convert -size 2600x3365 xc:white \
		-gravity center \( ${piece}.png -resize '2400x3000' \) -composite \
		-gravity center -pointsize 48 -annotate +0-1600 \
		"${label_info}  :   ${piece}" \
		-gravity SouthEast -pointsize 48 -annotate +100+50 "${thedate}" \
		${piece}.png

done

convert deface.png face.png face_plus.png reface.png reface_plus.png "${out_dir}"/refacer.pdf
rm deface.png face.png face_plus.png reface.png reface_plus.png
