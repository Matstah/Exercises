clear all
load('Ex9_PingData.mat')
%im1 = ImL{1}; gets first image out of cell.. 
run('/Users/matthustahli/Desktop/exchange/Computer Vision/Exercise/EX6 Exercise on feature matching/vlfeat-0.9.21/toolbox/vl_setup.m');
X1 =[];
originalImL =ImL;
originalImR =ImR;
BWL = {};
P1 = {};
BWR = {};
P2 = {};
len = length(ImL)-1;
%% substract Background and 
for i=1:len
   BWL{i} = rgb2gray(BaseL -ImL{i}) > 10;
   BWL{i}(:,350:end) = 0;
   pause(0.1);
   s = regionprops(BWL{i},'Centroid');
   P1{i} = s.Centroid;
   im = insertMarker(originalImL{i},P1{i},'Size',5);
   imshow(im);
end
for i=1:len
   BWR{i} = rgb2gray(BaseR -ImR{i}) > 10;
   BWR{i}(:,350:end) = 0;
   BWR{i}(:,1:200) = 0;
   pause(0.1);
   s = regionprops(BWR{i},'Centroid');
   P2{i} = s.Centroid;
   im = insertMarker(originalImR{i},P2{i},'Size',5);
   imshow(im);
end

%% Estimate 3D Point  %same 3D point on two images: P1{},P2{}
Q={};
for i=1:len
    b1 = [CamL(3,:)*P1{i}(1)-CamL(1,:); CamL(3,:)*P1{i}(2)-CamL(2,:)];
    b2 = [CamR(3,:)*P2{i}(1)-CamR(1,:); CamR(3,:)*P2{i}(2)-CamR(2,:)];
    B = [b1; b2];
    [U,S,V] = svd(B);
    q=V(:,end);
    Q{i}=q./q(4);
end

%% plot points in 3D

figure('name','3d plot')
hold on;
X=[];
Y=[];
Z=[];
for i = 1:len 
   %plot3(Q{i}(1),Q{i}(2),Q{i}(3),'*');
   X=[X;Q{i}(1)];
   Y=[Y;Q{i}(2)];
   Z=[Z;Q{i}(3)];

   %text(Q{i}(1),Q{i}(2),Q{i}(3), int2str(i));
end
plot3(X,Y,Z,'-');
grid on;
zlabel('z');
xlabel('x');
ylabel('y');
cameratoolbar
view(3);

figure('name','time-yplot=hight')
hold on;
for i = 1:len
   plot(i, -Q{i}(2),'*'); %y= -Q{i}(2), - because of flip of screen..
   %text(i,int2str(i));
end
grid on;




