clear all; close all; clc;

%we modify the House2 via Homography, and run the algo again.. see what
%happens. We should see that correlation is doing bad for rotated images..
%a lot of maches are wrong!
%% 

% Load the images
im1 = imread('House1.bmp');
im2 = imread('House2.bmp');

%% Q2 %image is rotated 20°
%a=20*pi/180;
a=45*pi/180; %almost all matches are wrong
s=sin(a);
c=cos(a);
%rotation:
%H=[c s 0;-s c 0;0 0 1];

s=0.4;
% x stays x, y stays y, but gets addes an offset of s*x.. so as larger x,
% as lager the offset.. 
%affine transformation: 6dof=3points.= all points lying on the line are
%still on the line. Still not so robust, but way better than with rotation!
% ??? why is this better than rotation??
H=[1 0 0; s 1 0; 0 0 1]; %=shear!!
%Note That H has to be transposed here if column vectors are used for points
Tr=maketform('projective',H');
WarpIm=imtransform(im2,Tr);
im2=WarpIm;

%% Extract the corners.
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
numberOfMatches = length(matches(:,1));
showMatchedFeatures(im1,im2,corners1(matches(:,1),:), corners2(matches(:,2),:),'montage')
