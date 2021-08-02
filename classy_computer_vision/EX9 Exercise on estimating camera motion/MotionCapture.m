clear all;
load('CamMotionData');
%% show image sequence
%{
imagesc(Im1);
pause(0.5)
imagesc(Im2);
pause(0.5)
imagesc(Im3);
BW=mat2gray(Im1);
pause(0.5)
imshow(BW);
%}
%% Q1 Extract SIFT features
%initialize vl_setup
run('/Users/matthustahli/Desktop/exchange/Computer Vision/Exercise/EX6 Exercise on feature matching/vlfeat-0.9.21/toolbox/vl_setup.m');
%Extract SIFT features from images
[F1, D1] = vl_sift(Im1,'FirstOctave',1); %D is the descriptor of the corresponding frame in F
[F2, D2] = vl_sift(Im2,'FirstOctave',1);
[F3, D3] = vl_sift(Im3,'FirstOctave',1);

%% Q3
Sigma = 3;

[M12,E12,R12,t12] = MatchImagePair(F1,D1,F2,D2,K,Sigma); %Q2
[M23,E23,R23,t23] = MatchImagePair(F2,D2,F3,D3,K,Sigma);

%plotMatchedFeatures(M12,F1,F2,Im1,Im2);
%plotMatchedFeatures(M23,F2,F3,Im2,Im3);

%% Q4 Compute the 2D features that are matches over all three images
[~,Idx12,Idx23] = intersect(M12(2,:),M23(1,:)); %we only case about the idx where the data is common, not its value

%% Q5 common feature points over all 3 images:

M12 = M12(:,Idx12);
M23 = M23(:,Idx23);

%% Q6 Form camera one and two. Set camera one to global origin.
R1 = eye(3,3); 
t1 = zeros(3,1);
cam1 = K*[R1,t1]; %pinhole model: P=A*[R t], A= internal, R=rotation, t=translation
%R12 = R12*R1;% ==R12
R12=[0.9999 -0.0093 -0.0122; 0.0099 0.9988 0.0473; 0.0117 -0.0474 0.9988];
t12 = [0.9296; -0.0667; -0.3717];
%t12 = t1 + t12;% ==t12
cam2 = K*[R12,t12]; %R12 is rotation from camera 1 to camera 2. 


%% Q7 (works) From features out of one and two, compute 3D point (matched in all)
Q=[];
p1 = [F1(1,M12(1,:)); F1(2,M12(1,:)); ones(1,length(M12))]; % put points into homo coordinates
p2 = [F2(1,M12(2,:)); F2(2,M12(2,:)); ones(1,length(M12))];
%for debugging
%cam1=[800 0 300 0; 0 800 400 -2400;0 0 1 0];
%cam2 = [800 0 300 0; 0 800 400 2400; 0 0 1 0];
%p1=[300;160;1];
%p2=[300;640;1];
for i=1:length(M12)
    b1 = [cam1(3,:)*p1(1,i)-cam1(1,:); cam1(3,:)*p1(2,i)-cam1(2,:)];
    b2 = [cam2(3,:)*p2(1,i)-cam2(1,:); cam2(3,:)*p2(2,i)-cam2(2,:)];
    B = [b1; b2];
    [U,S,V] = svd(B);
    q=V(:,end);
    Q=[Q, q./q(4)];
    %plot3d
end

figure(1)
plot3(Q(1,:),Q(2,:),Q(3,:),'o')

%i feel that i get weard (to small) results here..
%% Q9 Camera resectioning is the process of estimating the parameters of a pinhole camera model approximating the camera that produced a given photograph
%write a funciton that finds Pinhole camera model with regard to feature
%points.. 
q3 = [F3(1,M23(2,:)); F3(2,M23(2,:)); ones(1,length(M23))]; %known points in 2d image of camera3
figure(2)
plot(q3(1,:),q3(2,:),'o')

Cam3 = CamResectioning(q3,Q); %Q8 %normalized

%% Q10 based on Q & cam3, compute projections in 3th image: p3 = P*Q

p3 = Cam3*Q;
% normalize to get x,y on image: "NON homogeneous coordinates"
for i=1:size(p3,2)
    p3(:,i) = p3(:,i)./p3(3,i);
end

figure('name', 'matches, not clean')
clf;
imshow(cat(2, mat2gray(Im2), mat2gray(Im3)));
hold on ;
randm = randperm(length(p2),200);
h = line([ p2(1,randm); p3(1,randm)+size(Im2,2)], [p2(2,randm) ; p3(2,randm)]) ;
set(h,'linewidth', 0.01, 'color', 'c') ;
axis image off;


%% Q11 compute the reprojection error: the unhomogeneous distance between q3 ans p3.

dist =[];
for i=1:length(p3)
    d = sqrt(sum((q3(:,i)-p3(:,i)).^2)); %both vectors have s=1, so their substraction only leaves non homogeneous.
    dist = [dist,d];
end

% Q12 using points with less than 30 off to compute cam3
indx = dist < 30;

figure('name', 'matches, <30 p3 to q3')
clf;
imshow(cat(2, mat2gray(Im2), mat2gray(Im3)));
hold on ;
h = line([ p2(1,indx==1); p3(1,indx==1)+size(Im2,2)], [p2(2,indx==1) ; p3(2,indx==1)]) ;
set(h,'linewidth', 0.01, 'color', 'c') ;
axis image off;
% Q13/Q14 as I did not use Ransac:
%Estimate Cam3 with random 6 points.. then look at number of inliners:
%poinds with dist<30... after N iterations, take the best Cam3, and get rid
%of all outliners: dist>=30. then recalculate Cam3 with ALL inliners-> this
%gives my best guess for Cam3.

% Q15 do the same but with matches that are in all four images
% Ask TA about this..

