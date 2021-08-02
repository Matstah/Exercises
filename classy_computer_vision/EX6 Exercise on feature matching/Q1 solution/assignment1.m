clear all; close all; clc;


%% 

% Load the images
im1 = imread('House1.bmp');
im2 = imread('House2.bmp');

% Extract the corners.
harris1 = detectHarrisFeatures(im1);
harris2 = detectHarrisFeatures(im2);
[B, ci1] = sort(harris1.Metric, 'descend');  %[B,I]=sort, B = A(I)
[B, ci2] = sort(harris2.Metric, 'descend');
% Covnert to integers as we need whole array indices
corners1 = int32(harris1.Location(ci1(1:800),:)); %gives me the best 800 corner position within image. 
corners2 = int32(harris2.Location(ci2(1:800),:));
n = 7;

% For all corners in im1 find corresponding corners in im2
for ii = 1:size(corners1, 1)
    [idx, rho] = CornerXCorr(corners1(ii, :), corners2, im1, im2, n);
    match1(ii) = idx; %index is the index of the corner in corners2..
end

% Vice-versa
for ii = 1:size(corners2, 1)
    [idx, rho] = CornerXCorr(corners2(ii, :), corners1, im2, im1, n);
    match2(ii) = idx;
end

%%
% Allow only matches from im1 to im2 that is matches in im2 to im1. 
matches = [];
for ii = 1:length(corners1)
    if ~isnan(match1(ii))
        if match2(match1(ii)) == ii
            matches(end+1, :) = [ii match1(ii)];
        end
    end
end



%%

showMatchedFeatures(im1,im2,corners1(matches(:,1),:), corners2(matches(:,2),:),'montage')
