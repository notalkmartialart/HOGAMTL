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
outputDir = strcat(inputDir, 'patches/');
% if output directory does not exist then create it
if(exist(outputDir, 'dir') == 0)
    mkdir(outputDir);
end

display('Began preparing training data...');
tic;

% Run through all images
nImages = length(imageFiles);
for i =  1: nImages
    % Read image and convert to a grayscale and double matrix
    imageName = imageFiles(i).name;
    image = imread(strcat(inputDir, imageName));
    image_be = im2double(image);    
    % Divide the image into patchSize x patchSize size patches
    imagePatches = getImagePatches_3(image_be, patchSize); 
    
    [rowDim, colDim,dim] = size(imagePatches);
    normalized = zeros(rowDim * patchSize, colDim * patchSize);
    rowPatchSizeVector = patchSize * ones(1, rowDim);
    colPatchSizeVector = patchSize * ones(1, colDim);
    for d=1:dim
        normalizedPatches(:,:,d) = mat2cell(normalized, rowPatchSizeVector, colPatchSizeVector);
    end
    for r = 1 : rowDim
        for c = 1 : colDim
            for d=1:dim
                patch(:,:,d)=imagePatches{r,c,d};
            end
              normalizedPatches{r,c}= patch;
        end
    end
    
    patchesOutputDir = strcat(outputDir, imageName(1 : end - 4), '/');
    if(exist('patchesOutputDir', 'dir') == 0)
        mkdir(patchesOutputDir);
    end
    % Run through all patches 
    for r = 1 : rowDim
        for c = 1 : colDim
        % form name for the patch image
            patchName = strcat(imageName(1 : end - 4), '_patch_', num2str(((r - 1) * colDim) + c));
            outFile = strcat(patchesOutputDir, patchName, '.bmp');
            imwrite(normalizedPatches{r,c}, outFile);
        end
    end
    clearvars normalizedPatches
end
