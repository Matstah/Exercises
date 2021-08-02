% matching Harris corner’s via correlation

House1= imread('House1.bmp');
House2= imread('House2.bmp');

n=7; %patch size

%test Q1.1 & 1.2:
%{
figure('name','select one point')
imshow(House1);
[x,y] = ginput(1)
patch1 = extractPixelPatch(House1,x,y,n);
%size(patch1)
%B=patch1;
figure('name','extracted patch');
subplot(1,2,1)
RGB = insertMarker(House1,[x,y],'s','size',n);
imshow(RGB)
title('Original Image')
subplot(1,2,2)
imshow(patch1)
title('patch Image')
%}


% Q1.3 test
%{
A = zeros(41,41);
%cross correlation can be understood as the dot product of two vectors. So
%we get a measure on how far they are apart/different.. we substract the
%mean and divide by the standart deviation to substract light and noice..
%so if P1==P2, we get cos()=1, meaning that the angle(difference) is zero..
B=zeros(3,3)
Cross = crossCorrelation(A,B) 
%}

%Q1.4 
%gives me the point where we had the highest cross-correlation (we did not look at harris corner within that patch..)
%{
[x2,y2] = findCorner( House2, patch1 )

figure('name','patch with highest cross correlation')
subplot(1,4,1)
RGB = insertMarker(House1,[x,y],'s','size',n);
imshow(RGB)
title('Original Image')
patch2 = extractPixelPatch(House2,x2,y2,n);
subplot(1,4,2)
RGB2 = insertMarker(House2,[x2,y2],'s','size',n);
imshow(RGB2)
title('Second Image')
subplot(1,4,3)
imshow(patch2)
title('selected patch Image')
subplot(1,4,4)
imshow(patch1)
title('given patch Image')
%}

%extract numOfCorners strongest corners, and find theire patches. Harris corners:

%It works, but it is very slow!
numOfCorners =3; %number of corners to be mached..
figure('name','Extracted Harris corners')
pointsInIm1 = detectHarrisFeatures(House1);
strongest = pointsInIm1.selectStrongest(numOfCorners);
position = strongest.Location;% == (x,y) coordinates
imshow(House1); hold on;
plot(strongest);

matchedPoints = zeros(numOfCorners,2);
patch1=zeros(2*n+1,2*n+1);
%for all corners in image 1 find corresponding corners in im2.
for i=1:numOfCorners
    patch1 = extractPixelPatch(House1,position(i,1),position(i,2),n);
    [x,y] = findCorner(House2, patch1); %we could also just give all corners on House2 and n.. as a strong corner needs to be in both pictures.. then we don't need to go over all pixels in the image..
    matchedPoints(i,1)=x;
    matchedPoints(i,2)=y;
end
figure('name', 'all matches')
subplot(1,2,1)
Im1= insertMarker(House1,position,'s','size',n);
imshow(Im1)
title('image 1')
subplot(1,2,2)
Im2 = insertMarker(House2,matchedPoints,'s','size',n);
imshow(Im2)
title('image 2')



figure('name','patch with highest cross correlation')
subplot(1,4,1)
RGB = insertMarker(House1,[position(1,1),position(1,2)],'s','size',n);
imshow(RGB)
title('Original Image')
subplot(1,4,2)
RGB2 = insertMarker(House2,[matchedPoints(1,1),matchedPoints(1,2)],'s','size',n);
imshow(RGB2)
title('Second Image')
subplot(1,4,3)
patch2 = extractPixelPatch(House2,matchedPoints(1,1),matchedPoints(1,2),n);
imshow(patch2);
title('patch2 Image')
subplot(1,4,4)
imshow(patch1);
title('patch1 Image')





