function normalizedPatches = normalizeLocalContrast_3(imagePatches, windowSize, patchSize)
% pre-allocate output memory
[nRowPatches, nColPatches,dim] = size(imagePatches);
normalized = zeros(nRowPatches * patchSize, nColPatches * patchSize);
rowPatchSizeVector = patchSize * ones(1, nRowPatches);
colPatchSizeVector = patchSize * ones(1, nColPatches);
for d=1:dim
    normalizedPatches(:,:,d) = mat2cell(normalized, rowPatchSizeVector, colPatchSizeVector);
end

gaussian=fspecial('gaussian',windowSize,3);%得到高斯滤波核

% Run through all patches
for r = 1 : nRowPatches
    for c = 1 : nColPatches
         for d=1:dim
             middle=imagePatches(:,:,d);
             patch(:,:,d) = middle{r, c};
         end
        % Compute local mean
        meanPatch=imfilter(patch,gaussian);
        % Compute local standard deviation
        stdDevPatch=sqrt(imfilter((patch-meanPatch).^2,gaussian));
        % Subtract local mean and divide by local standard deviation and add a
        % small constant to denominator in order to avoid division by zero
        normalizedPatches{r,c}= (patch - meanPatch) ./ (stdDevPatch + 1e-8);
        
            
    end
end
end