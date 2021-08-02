%im = imread('TestIm1.bmp');
%Q9
im=imread('TestIm2.bmp');
%im=imread('House1.bmp');
im=imread('House2.bmp');
sigma = 3;
t=sigma*sigma;
x=-3*ceil(sigma):3*ceil(sigma);
g=exp(-x.*x./(2*t))/sqrt(2*pi*t); %1D gaussian
gx=(-x/t).*exp(-x.*x./(2*t))/sqrt(2*pi*t); %1D derivative of gaussian 

Ix= filter2(gx,im,'same');
Ix= filter2(g',Ix,'same');
Iy= filter2(g,im,'same');
Iy= filter2(gx',Iy,'same');

%Q1: sigma gives us the variance of the gaus == how far it spreads.. as we
%need to include like the whole thing.. at 3*sigma from center, we include
%99.7% of the area... very good approx of actual thing...

%Q2:??? for only smoothing, we just need to apply the gaussian.. so go
%convolution of image with gaussian. why is it here done in 2x1D and not a
%convolution with 2D..?

% (g(xdirection)*g'(=g yDirection)*Image % order of confolution doesn't
% matter
im= filter2(g',im,'same'); %gaussian in y direction
im= filter2(g,im,'same'); %gaussian in x direction
%imshow(im)

%Q3:
Ix2 = filter2(g',Ix.^2,'same');
Ix2= filter2(g,Ix2,'same');
%imshow(mat2gray(Ix2));

Iy2 = filter2(g',Iy.^2,'same');
Iy2= filter2(g,Iy2,'same');
%imshow(mat2gray(Iy2));

Ixy = filter2(g',Ix.*Iy,'same');
Ixy= filter2(g,Ixy,'same');
%imshow(mat2gray(Ixy));

%Q4
k=0.06;
R = Ix2.*Iy2 - Ixy.^2 -k*(Ix2+Iy2).^2;
%R = mat2gray(R);
R= mat2gray(R);
figure('name','R values');
imshow(R);
%Q5
maxR = max(max(R));

%Q6: 
cornerTresh = 0.4*maxR;
mask = zeros(size(R));
mask(R > cornerTresh) = 1;
R=R.*mask; %this is needed, as else maximum suppression would make no sense

figure('name','above treshhold');
imshow(mat2gray(R));

%Q7: maximum suppression 
%Go trough all pixel. If current pixel has highest value in neighbourhood,
%then take it, else set to zero.
[x,y] = size(R); %[x,y]
bw = zeros([x,y]);

for xItr=2:x-1  %start at 2 because of image edge.. just assume that no corner at the image edge.. this makes sense as we would not know if it was an edge or corner..
    for yItr=2:y-1
        win4 = [0 R(xItr,yItr-1) 0; R(xItr-1,yItr) R(xItr,yItr) R(xItr+1,yItr); 0 R(xItr,yItr+1) 0];
        win8 = [R(xItr-1,yItr-1) R(xItr,yItr-1) R(xItr+1,yItr-1); R(xItr-1,yItr) R(xItr,yItr) R(xItr+1,yItr); R(xItr-1,yItr+1) R(xItr,yItr+1) R(xItr+1,yItr+1)];
        if win4(2,2)~=0
            bw(xItr,yItr)= win4(2,2)>=max(max(win4));
        end
    end
end

%Q8
figure('name','after non-max suppression')
[pointx, pointy] = find(bw');
cornerImage = insertMarker(bw,[pointx, pointy]);
imshow(cornerImage);
figure('name', 'detected corners')
imshow(insertMarker(mat2gray(im),[pointx, pointy]));


