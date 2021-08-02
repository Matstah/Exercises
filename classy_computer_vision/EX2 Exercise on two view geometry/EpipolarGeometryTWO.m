load ('TwoImageData.mat');

%Q9: multiply both sides with R'. As R is rotation matrix, we know that
%R'=inv(R). easy... paper

%Q10: paper

%Q11: Compute fundamental matrix between the two images
% ??? what if both cameras not at center? is that what question 10 means?
F = inv(A)'*CrossOp(T2)*R2*inv(A);

%{
%Q12: 
%pick a pixel in first image
imshow(im1);
q1=[ginput(1) 1]'; %manually picked point in first image
%compute epipolar line in second image
l2=F*q1; % gives me line parameters

%when we plot the two images, we see that for camera two, we turn a little
%bit to the right. therefor we get an almost strait line.. is this true?
figure(1);
im1 = insertMarker(im1,q1(1:2)');
imshow(im1);

figure(2);
imshow(im2);
DrawImageLine(600 ,800, l2); %is this true?

figure(3);
imshow(im1-im2);
%}

%Q13: same as Q12, but choose point from image two, and plot line to image1.
imshow(im2);
%q2=[ginput(1) 1]';
q2=[191, 481, 1]';
l1 = F'*q2;

figure(2);
im2 = insertMarker(im2,q2(1:2)');
imshow(im2);
q1=[192.803086774275,482.655305998399,1]';
figure(1);
im1 = insertMarker(im1,q1(1:2)');
imshow(im1);
DrawImageLine(600 ,800, l1'); %is this true?


