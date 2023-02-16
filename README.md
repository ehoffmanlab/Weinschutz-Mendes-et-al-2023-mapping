# Whole-brain mapping and analysis codes

The following method was used in Weinschutz Mendes et al. (2023) to analyze whole-brain confocal z-stack images of 6 dpf larval zebrafish brains immunostained for active (pERK) and total (tERK) neurons. In Weinschutz Mendes et al. (2023), this method was used to identify brain volume and activity phenotypes in zebrafish mutants of autism genes. The method is described in the STAR Methods section of Weinschutz Mendes et al. (2023). 

### Preprocessing and file conversion

1. Convert z-stack microscopy images (e.g., `.lif`) to `.nrrd` files using ImageJ.
2. Convert .nrrd files to `.nii.gz` files using BioImage Suite (https://bioimagesuiteweb.github.io/webapp/viewer.html#).

### Registration and analysis (BioImage Suite Web Node)

3. Register all .nii files using the `nonlinearregistration` module of BioImage Suite Web Node, `biswebnode`.
4. Reslice tERK-labeled images to a standard zebrafish reference brain (Randlett et al. 2015) using the `resliceImage` module, which generates a transformation file (`.bisxform`) and a registered file (`r_*.nii.gz`).
5. For volume analysis, use the `jacobianimage` module, which generates jacobian files for each `.bisxform` file, and the `maskimage` module to generate masked versions of the jacobian files (`mask_ja*.nii.gz`).
6. For activity analysis, the `divided.sh` script is used to divide the registered `*C0*.nii.gz` (pERK) and `*C1*.nii.gz` (tERK) images, generating `*C0divC1*.nii.gz` files. This script requires FSLMaths (https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/FslInstallation). 
7. To generate ROI values for activity (`*C0divC1*.nii.gz`) or volume (`mask_ja*.nii.gz`) files, use the computeroi module in biswebnode. This step requires using a zebrafish brain atlas (e.g., Randlett et al. 2015) for activity quantification and a resampled version of the zebrafish atlas for volume quantification.
The MATLAB script `BREEZE_zscore.m` is used to calculate a zscore for both activity (`*C0divC1*.nii.gz`) and volume (`mask_ja*.nii.gz`) files by comparing experimental and control groups. This script requires MATLAB.

The software package Analysis of Functional NeuroImages (AFNI) (Cox et al. 1996, https://afni.nimh.nih.gov/) is used to analyze the z-score images prior to visualization.

Images processed by AFNI can be visualized using BioImage Suite WebApp Dual Viewer (https://bioimagesuiteweb.github.io/webapp/dualviewer.html#) and BioImage Suite Overlay Viewer (https://bioimagesuiteweb.github.io/webapp/overlayviewer.html#).

[![DOI](https://zenodo.org/badge/601793544.svg)](https://zenodo.org/badge/latestdoi/601793544)

