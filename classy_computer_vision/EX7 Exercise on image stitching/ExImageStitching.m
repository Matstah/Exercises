%% Q1 Test Hest function
% run('/Users/matthustahli/Desktop/exchange/Computer Vision/Exercise/EX6 Exercise on feature matching/vlfeat-0.9.21/toolbox/vl_setup.m');

q1=rand(3,4); % 4 points, 
Htrue=[10 0 -1;1 10 20;0.01 0 3];
q2 = Htrue*q1;
H = Hest(q1,q2);

Htrue = Htrue./Htrue(3,3)
H = H./H(3,3) %done to be able to compare

%we have a rounding error, so we can not do isequal.. but it is...


%% Q2 

ImL = imread('ImL.jpg');
ImR = imread('ImR.jpg');
[fa, da] = vl_sift(single(rgb2gray(ImL))); % fa (points), da (128 dimension)
[fb, db] = vl_sift(single(rgb2gray(ImR)));
[matches, scores] = vl_ubcmatch(da, db,3); %this 3 has something to do with threshold.. standart is 1.5... so in my case it does the job of the ransac kind of.. need to implement ransac. Which distance are they talking about??
nMatch=size(matches,2);

figure('name', 'both paintings')
subplot(1,2,1); imshow(ImL);
subplot(1,2,2); imshow(ImR);

figure(2) ; clf ;
imagesc(cat(2, ImL, ImR));

xa = fa(1,matches(1,:)) ;
xb = fb(1,matches(2,:)) + size(ImL,2) ;
ya = fa(2,matches(1,:)) ;
yb = fb(2,matches(2,:)) ;

hold on ;
h = line([xa ; xb], [ya ; yb]) ;
set(h,'linewidth', 1, 'color', 'b') ;

vl_plotframe(fa(:,matches(1,:))) ;
fb(1,:) = fb(1,:) + size(ImL,2) ;
vl_plotframe(fb(:,matches(2,:))) ;
axis image off;

%% Q3 Use Ransac to fit a homography to the matches from Question 2, using homograhpy estimator from Q1.
%use xa, xb,ya,yb for point matches

X1 = [xa; ya; ones(1,length(xa))];  %changed length from nMatch to length(xa)
X2 = [xb- size(ImL,2); yb; ones(1,length(xb))]; %changed length(xb) from nMatch

H1 = Hest(X1,X2);
%H1=H./H(3,3);
H2 = inv(H1);



%i have 481 matches.. so without rancas i do an approximation with all 481
%matches, instead of a random sample of it.. also i dont realy check for
%outlaiers

% TODO RANSAC

%step 1: randomly draw sample / take n match points

%step 2: Estimate a model / with the n random samples, estimate H

%step 3: compute the consensus / compute how many datapoints computed with
%the estimated H are to far from approximation.. so we estimate the point
%to be at position x, bit it is 3cm away in reality..


P1_test = H2*X2;
P2_test = H1*X1;
%dist_1 = P2_test-X1;
%dist_2 = P1_test-X2;

%dist = (sqrt((dist_1(1,:).^2)+(dist_1(2,:).^2)).^2)+(sqrt((dist_2(1,:).^2)+(dist_2(2,:).^2)).^2);

%% Q4
figure('name', 'transformed')
subplot(1,2,1); imshow(ImL);
tform = maketform('projective',H1');
ImH= imtransform(ImL,tform);
imagesc(ImH);
axis image 


%% Q5

figure('name','warped images');
WarpNView(H1,ImL,ImR);

%??? Comment on the result, in particular what this imples about the quality of your estimate of the homography H

% the feature point are aligned, but this does not mean that the overall
% image looks like 'one'.. due to the transformation and the different
% lightning/ in the images at some parts, the image looks blurry. What we
% would need not is kind of a sharpening, or a decision tool, that looks at
% the overlaying pixels..


