function crossCorrValue = crossCorrelation( patch1, patch2 )
%calculates the crosscorrelation between two given image patches. 
%   implementation of table 6.1, page 114
%NOT EFFICIENT: if we would use this function to go trough all points of
%the image, we would need each pixel like 3 times.. mean, variance and set
%cross- correlation.

patch1 = double(patch1);
patch2 = double(patch2);

%step 2: arrange patch into vector
p1= reshape(patch1,[],1); %starts with first column, and adds second column below.
p2 = reshape(patch2,[],1);

%step 3: calculate the mean of each vector
m1 = mean(p1);
m2 = mean(p2);

%step 4: calculate the variance of each vector
v1 = var(p1);
v2 = var(p2);

% TODO: handle no variance, as then denominator is zero and
% crossCorrelation is undefined. And with little differenc, noice will
% dominate. But as we took corners with high variance, it will almost never
% be zero in real world. 

%step 5: calculate the covariance between the two vectors-- very sensitive
%to rotation and other changes in viewpoint.. not that much in intensity,
%as we substract the mean.. 
cov = (p1-m1).*(p2-m2);
summe = sum(cov);
cov= summe/(length(p1)-1); %this -1 comes from matlab, as array starts at 1.
crossCorrValue=cov/(sqrt(v1 * v2));
end

