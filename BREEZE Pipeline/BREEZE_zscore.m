tic
fslDirectory = '/home/project/fsl/bin'
referenceGroupList = textread('reference_group_list.txt','%s')
comparisonGroupList = textread('comparison_group_list.txt','%s')
meanRefImageName = 'mean_ref_fish_image.nii'
sdImageName = 'std_fish_image.nii'
referenceFishImage = 'standard_ref_dis.nii';

%% Set the FSL environment so that FSL commands may be used in Matlab
setenv('FSLDIR',fslDirectory); 
setenv('FSLOUTPUTTYPE', 'NIFTI_GZ');
%% Make a mean image of the WT
sumCommand = [fslDirectory '/fslmaths ' referenceGroupList{1}];
for image = 2:length(referenceGroupList)
    sumCommand = [sumCommand ' -add ' referenceGroupList{image}];
end   
meanCommand = [sumCommand ' -div ' num2str(length(referenceGroupList)) ' ' meanRefImageName];
system(meanCommand)

%% Open a Blank Fish
reference_fish = niftiread(referenceFishImage);

%% Load all WT fish into a line
referenceImages = [];
for image = 1:length(referenceImages)
    referenceImages =cat(4,referenceImages,niftiread([referenceGroupList{image}]));
end

%% Grab the Standard Deviation Along Fourth Dimension
referenceImages = std(referenceImages,0,4)
niftiwrite(referenceImages,[sdImageName]) % Now, use fslcpgeom to copy reference dimensions

%% Use fslcpgeom to copy reference dimensions
system([fslDirectory '/fslcpgeom ' referenceFishImage ' ' sdImageName])
system(['gzip -f ' sdImageName])

%% Z-Score the images according to the Reference mean
for image = 1:length(referenceGroupList)
    stringToExecute = [fslDirectory '/fslmaths ' referenceGroupList{image} ' -sub ' meanRefImageName ' -div ' sdImageName '.gz ' referenceGroupList{image}(1:end-7) '_zscore.nii.gz'];
    system(stringToExecute)
end


%%Comparison
for image = 1:length(comparisonGroupList)
    stringToExecute = [fslDirectory '/fslmaths ' comparisonGroupList{image} ' -sub ' meanRefImageName ' -div ' sdImageName '.gz ' comparisonGroupList{image}(1:end-7) '_zscore.nii.gz'];
    system(stringToExecute)
end

toc