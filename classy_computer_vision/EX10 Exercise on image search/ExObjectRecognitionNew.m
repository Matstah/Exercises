clear all ; close all ; clc ; 
run('/Users/matthustahli/Desktop/exchange/Computer Vision/Exercise/EX6 Exercise on feature matching/vlfeat-0.9.21/toolbox/vl_setup.m');
%%
image_count = 100;
images = zeros(image_count, 480, 640); 
SIFT_features = {image_count};
SIFT_descriptors = {image_count};
for image_index = 1:image_count
    if  ~mod(image_index , 10)
        fprintf('Extracting features from image %03d of %03d\r', image_index , image_count);
    end
    filename = sprintf ( 'ukbench%05d.jpg' , image_index - 1) ; % MATLAB 1−index to images 0−index .
    filepath = fullfile('ukbench', filename);
    im = rgb2gray(imread(filepath));
    images(image_index , : , :) = im;
    [f, d] = vl_sift(single(im));
    SIFT_features{image_index} = f ; 
    SIFT_descriptors{image_index} = d;
    
end
save( 'SIFTdescr.mat' , 'SIFT_descriptors' , 'SIFT_features' , 'images');
%%
clear all ; close all ; clc ; 
load( 'SIFTdescr.mat' );
fprintf('SIFT loaded');
queryIdx=20;

%% K-means Clustering
k = 50; %one sift descriptor has dimention 1x128, 3-D histogram (consisting of 8×4×4=128 bins)
queryDescriptor = SIFT_descriptors{queryIdx};
SIFT_descriptors(queryIdx) = []; %deletes query image out of cell..

allDescriptors = [];
for i=1:length(SIFT_descriptors)
    allDescriptors = [allDescriptors, SIFT_descriptors{i}];
end

%for each sift feature in each image, detemine which clustere is closest.
[idx,C,sumd,D] = kmeans(double(allDescriptors)',k); %index tells me for each descriptor in which cluster it is.. so first descriptor of image 2 has indey 42, so it is in cluster 42
% C is k-by-p matrix, with k beeing cluster number, and p the point of
% cluster center

%for each image, make a normalised k-bin histogram
histograms = zeros(k,length(SIFT_descriptors));
votes = idx;
for i=1:length(SIFT_descriptors)
    
        h=histcounts(votes(1:length(SIFT_descriptors{i})),k); %normalize to compare them to other histograms... as we want the relation..
        h = h./sum(h); 
        histograms(:,i) = h;
        votes = votes(length(SIFT_descriptors{i})+1:end); %cut of the image just handled
    
end
%bar(histograms(:,>imageNumber<)) %to plot histogram

%% claculate histogram of our image: determine for each descriptor its closest cluster and vote for that one.

queryVotes = kmeans(double(queryDescriptor)',k,'Start',C);
queryVotes= histcounts(queryVotes,k);
queryHist= queryVotes./sum(queryVotes);
figure('name', 'histogram queryImage')
bar(queryHist);

%%compare distance of queuery histogram to the rest of the image histograms
distToImages = zeros(1,length(SIFT_descriptors));
queryAdded =0;
for i=1:(length(SIFT_descriptors)+1)
    if queryIdx ~= i
        distToImages(1,i) = dist(queryHist, histograms(:,i-queryAdded));
    else
        queryAdded=1;
    end
end

bar(distToImages)


%take smallest distance as the 'same' image


% take query image out of creating kmeans, so we need eucledian distance to
% determine to which bin each each descriptor belongs...





