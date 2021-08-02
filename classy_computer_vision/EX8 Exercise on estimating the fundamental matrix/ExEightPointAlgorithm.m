clear all; clc;
%use feature matcher to calculate fundamental matrix to improve feature
%matcher. 

% run('/Users/matthustahli/Desktop/exchange/Computer Vision/Exercise/EX6 Exercise on feature matching/vlfeat-0.9.21/toolbox/vl_setup.m');

%house1 = imread('House1.bmp');
%house2 = imread('House2.bmp');

%% Q2 
%load the two images
load('TwoImageData.mat')
load('Qtest.mat')
house1 = im1;
house2 = im2;
%initialize vl_setup
run('/Users/matthustahli/Desktop/exchange/Computer Vision/Exercise/EX6 Exercise on feature matching/vlfeat-0.9.21/toolbox/vl_setup.m');
%get features via sift..
[fa, da] = vl_sift(single(house1));
[fb, db] = vl_sift(single(house2));
[matches, scores] = vl_ubcmatch(da, db); %set treshhold if needed..%score= square eucledian distance
nMatch=size(matches,2);

figure('name', 'both paintings');
clf;
imshow(cat(2, house1, house2));

xa = fa(1,matches(1,:));
ya = fa(2,matches(1,:));
xb = fb(1,matches(2,:))+ size(house1,2) ;
yb = fb(2,matches(2,:));

hold on ;
h = line([xa ; xb], [ya ; yb]) ;
set(h,'linewidth', 0.01, 'color', 'c') ;

vl_plotframe(fa(:,matches(1,:))) ;
fb(1,:) = fb(1,:) + size(house1,2) ;
vl_plotframe(fb(:,matches(2,:))) ;
axis image off;

%% Q3 F estimation via RANSAC
xa = fa(1,matches(1,:));
ya = fa(2,matches(1,:));
xb = fb(1,matches(2,:));
yb = fb(2,matches(2,:));

X1 = [xa;ya;ones(1,length(xa))]; %feature location on image1.
X2 = [xb;yb;ones(1,length(xb))]; %same features on image2.

n = 50; % number of iterations
best_nIn = 0; 
best_F = zeros(3,3);
inIdx =[];

for j=1:n
    idx = randperm(nMatch);
    idx = idx(1:20);
    Fest = Fest_8point(int32(X1(:,idx)), int32(X2(:,idx)));
    nIn=0;
    tracker = [];
    for cM=1:nMatch
        if(FSampDist(Fest,X1(:,cM),X2(:,cM))<3.84*3^2) %cv.sampsonDistance(pt1, pt2, F)
            nIn=nIn+1;
            tracker = [tracker,cM];
        end
    end
    if best_nIn < nIn
       best_nIn = nIn;
       inIdx = tracker; %Q4 all my inliners with regard to my estiated F.
       best_F = Fest;
    end 
end

%% Q4 use all inliners to estimate a more exact F

%refine estimated F by running Fest_8point with all the inliners. 
FrefineEst= Fest_8point(X1(:,inIdx),X2(:,inIdx));

%compare best_F with FrefineEst and Ftrue
FrefineEst= FrefineEst./FrefineEst(3,3);

%illustrate the matched inliners
figure(2) ; clf ;
imshow(cat(2, house1, house2));
hold on ;

%conclusion: we only see straight lines.. in figure(1), we also saw lines
%that where going up and down.. no wrong matches.. 

inLine=0;
%goodMatches = [];
for cM=1:nMatch
    if(true && FSampDist(FrefineEst,X1(:,cM),X2(:,cM))<3.84*3^2) %cv.sampsonDistance(pt1, pt2, F)
        %draw
        a = X1(:,cM);
        b = X2(:,cM);
        h = line([a(1) ; b(1)], [a(2) ; b(2)]) ;
        set(h,'linewidth', 0.1, 'color', 'c') ;
        inLine=inLine+1;
        %goodMatches = [goodMatches,cM]; %those are now my mached inliners, and should be used for imache stitching..
    end
end

%{
figure(2) ; clf ;
imshow(cat(2, house1, house2));
hold on ;
test =0
for cM=1:nMatch
    if(FSampDist(best_F,X1(:,cM),X2(:,cM))<3.84*3^ 2)
        a = X1(:,cM);
        b = X2(:,cM);
        test = test+1;
       	h = line([a(1) ; b(1)], [a(2) ; b(2)]) ;
        set(h,'linewidth', 1, 'color', 'b') ;
    end
end
%}

%use X1(:,tracker) and X2(:,tracker) for image stitching.. as they all lay
%in the area of inliners of our estimated fundamental matrix.

%use goodMatches to stitch images together..


%compare best with estimated F..
%Ftrue = estimateFundamentalMatrix(X1(1:2,:)',X2(1:2,:)');
%b=Ftrue(:);
%a=F(:);
%a'*b/(norm(a)*norm(b))
%ftrue= Ftrue./Ftrue(3,3);
%f=F./F(3,3);