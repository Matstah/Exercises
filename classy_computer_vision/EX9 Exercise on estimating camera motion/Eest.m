function [E, R, t, nIn] = Eest(K,q1,q2,Sigma)
% EEST estimate essential matrix from image correspondences.
% [E,R,t,nIn] = Eest(K,q1,q2,Sigma);
% Note that the computer vision toolbox is necessary for this function to work.
% January 2017, jnje@dtu.dk

cameraParams = cameraParameters('IntrinsicMatrix', K');
[E,eIn] = estimateEssentialMatrix(q2(1:2,:)',q1(1:2,:)',cameraParams,'MaxDistance', 3.84 * Sigma^2,'Confidence', 99.99, 'MaxNumTrials', 2000);
[R, t] = relativeCameraPose(E, cameraParams, q2(1:2,eIn)', q1(1:2,eIn)');
nIn = sum(eIn);
t = t';

