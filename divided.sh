#!/bin/bash


for file in `ls r_*gz | grep -v div | sed 's/_C.__optfixed.nii.gz//g' | uniq`
do
	echo ${file}
	fslmaths ${file}_C0__optfixed.nii.gz -div ${file}_C1__optfixed.nii.gz ${file}_C0divC1.nii.gz
done

