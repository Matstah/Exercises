im1 =imread('House1.bmp');
im2 =imread('House2.bmp');

%%
a=20*pi/180;
%a=45*pi/180; %almost all matches are wrong
s=sin(a);
c=cos(a);
%rotation:
H=[c s 0;-s c 0;0 0 1];

s=0.5;
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

%%
im1g = im2single(im1);
im2g = im2single(im2);

[f1,d1] = vl_sift(im1g) ;
[f2,d2] = vl_sift(im2g) ;

[matches, scores] = vl_ubcmatch(d1,d2);

numMatches = size(matches,2);

X1 = f1(1:2,matches(1,:)) ; X1(3,:) = 1 ;
X1=X1';
X2 = f2(1:2,matches(2,:)) ; X2(3,:) = 1 ;
X2=X2';

showMatchedFeatures(im1,im2,X1(:,1:2),X2(:,1:2),'falsecolor'); %'blend', 'montage'
