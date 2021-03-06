% Author: Adnan Chaudhry
% Date: September 21, 2016
%% Prepare training data for training the NR CNN for IQA


%%
clc;
clear;

% Image will be divided into patchSize x patchSize patches
patchSize = 32;
% window size used in local contrast normalization
% A window of windowSize x windowSize will be used
windowSize = 3;

% Prompt user for the directory holding input images
inputDir = uigetdir('.', 'Select input images'' directory');
inputDir = strcat(inputDir, '/');
% Get all image files in the directory
imageFiles = dir(strcat(inputDir, '*.bmp'));
% Output images' path
outputDir = strcat(inputDir, 'rgb_3_test/');
% if output directory does not exist then create it
if(exist(outputDir, 'dir') == 0)
    mkdir(outputDir);
end

display('Began preparing training data...');
tic;

%%
% Run through all images
nImages = length(imageFiles);
for i =  1: nImages
    % Read image and convert to a grayscale and double matrix
    imageName = imageFiles(i).name;
    image = imread(strcat(inputDir, imageName));
    image = im2double(image);    
    % Divide the image into patchSize x patchSize size patches
    imagePatches = getImagePatches_3(image, patchSize); 
    % Apply local contrast normalization to image patches
    normalizedPatches = normalizeLocalContrast_3(imagePatches,windowSize,patchSize);
    % Save normalized image patches to disk
    [rowDim, colDim,dim] = size(normalizedPatches);
    patchesOutputDir = strcat(outputDir, imageName(1 : end - 4), '/');
% if the directory does not exist then create it
    %if(strcmp(patchesOutputDir, '/home/xiaogao/Downloads/screen_content/SCID/distorted_after/rgb_3/img1647/'))
    if(exist('patchesOutputDir', 'dir') == 0)
        mkdir(patchesOutputDir);
    end
    % Run through all patches 
        for r = 1 : rowDim
            for c = 1 : colDim
        % form name for the patch image
                patchName = strcat(imageName(1 : end - 4), '_patch_', num2str(((r - 1) * colDim) + c));
                outFile = strcat(patchesOutputDir, patchName, '.bmp');
                %if ~exist(outFile,'file')
                imwrite(normalizedPatches{r,c}, outFile);
                %end
            end
        end
    %end
    %saveImagePatches_3(normalizedPatches, outputDir, imageName);
end

toc;
display('Finished preparing training data.')