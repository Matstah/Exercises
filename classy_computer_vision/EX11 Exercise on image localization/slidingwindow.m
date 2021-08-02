clear all; close all; clc;
run('../vlfeat-0.9.21/toolbox/vl_setup.m');
% -----------------------------------------------------------
% DOWNLOAD AND INITIALIZE VL_FEAT BEFORE RUNNING THIS SCRIPT.
% -----------------------------------------------------------
% stet, Technical University of Denmark, 06-05-2016

% Settings:
cellSize = 8;    %hog cell size (8)
scalesize = 0.5; %detect at different scales: 0.5, 0.7, 1, 0.1
im_q = imread('dturoad1.jpg'); %Query Image
im_q = imresize(im_q,scalesize); %change size of query image, therefore size relation from object to image changes compared to each other..

% Read Object Image:
im_obj = imread('sign1_64.jpg');


% Calculate HOG on Object- and Query-Image:
hog_obj = vl_hog(single(im_obj), cellSize);
hog_q = vl_hog(single(im_q), cellSize);


% Sliding Window: The Result is a distancescore matrix:
fun = @(block_struct) compareHog(block_struct.location,hog_q,hog_obj,cellSize);
d_scores = blockproc(zeros([size(hog_q,1) size(hog_q,2)]),[1 1],fun); 


%Visualize Distance Scores:
figure;
imagesc(d_scores);
title('Match Distance Scores'); colorbar;


% Find lowest distance
[lowest, idx] = min(d_scores(:)) ;
% Find position (in HOG cells) of lowest score
[hogy, hogx] = ind2sub(size(d_scores), idx) ;
x = (hogx - 1) * cellSize + 1 ;
y = (hogy - 1) * cellSize + 1 ;


% Visualize Detection
figure;
imagesc(im_q);
hold on;
rectangle('Position',[x-0.5 y-0.5 size(im_obj,1)-0.5 size(im_obj,2)-0.5],'EdgeColor','y', 'LineWidth',2);
title('Detection');
