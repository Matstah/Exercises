im2 = imread('TestIm2.bmp');
imshow(im2);
im = mat2gray(im2);

%Q2.1 applies canny edge detection
BW = edge(im,'Canny');
imshow(BW);

%Q2.2 what is the effect of the two threshold parameters in the Canny Edge
%detector?:
%default sigma is sqrt(2)
sigma = sqrt(2);
%[0.00625,0.015625] == [low, high] tresholds used by canny (if not given any)
%threshold= [0.00625,0.010625];%gradient is seen as lines.. why ???
threshold= [0.002,0.0021]; %[0.052,0.1021] %high!!

% threshold teremines the sensitivity to a change in graysacle in the level
% to detect it as an edge or not..
[BW,threshOut] = edge(im,'Canny',threshold,sigma);
imshow(BW);