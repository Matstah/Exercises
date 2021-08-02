close all;
Im = imread('petergade.png');

%??? why does this work without normalization? 
%??? WHY DO WE NORMALIZE???
%normalization should help to have a standart variation of 1.. so a
%position 10 times bigger than an other, does not result in 100 times
%bigger if both squared... (verzieht sich stark..)


hFig = figure(); imshow(Im);
%get coordinates in cartesian form (1 at the end)
q11=[ginput(1) 1]';
q12=[ginput(1) 1]';
q13=[ginput(1) 1]';
q14=[ginput(1) 1]';
close(hFig);

%all 4 corners in meter
q21 = [0;0;1];
q22 = [6.1;0;1]; %6.1 = 5.18 +2*0.46 = breite 
q23 = [6.1;13.4;1];
q24 = [0;13.4;1];

%both vectors with corresponding points in each image. 
X1 = [q11 q12 q13 q14];
X2 = [q21 q22 q23 q24];

%By normalizing the data set, you center your data and give it unit variance
% Mean1=mean(X1')';
% X1(1,:)=X1(1,:)-Mean1(1); %substract xmean of all x values.
% X1(2,:)=X1(2,:)-Mean1(2); %substract ymean of all y values.
% S1=mean(sqrt(diag(X1'*X1)))/sqrt(2);
% X1(1:2,:)=X1(1:2,:)/S1;
% T1=[eye(2)/S1,-Mean1(1:2)/S1;0 0 1]; %?

% Mean2=mean(X2')';
% X2(1,:)=X2(1,:)-Mean2(1);
% X2(2,:)=X2(2,:)-Mean2(2);
% S2=mean(sqrt(diag(X2'*X2)))/sqrt(2);
% X2(1:2,:)=X2(1:2,:)/S2;
% T2=[eye(2)/S2,-Mean2(1:2)/S2;0 0 1];



%min(B*vec(H))=H..== min(X1'(i)(kroneker product)[X2(i)]*vec(H))..
K1 = kron(X1(:,1)',CrossOp(X2(:,1))); %gives me a 3*1 x 3*3 matrix
K2 = kron(X1(:,2)',CrossOp(X2(:,2))); % done for one pixel pair... 
K3 = kron(X1(:,3)',CrossOp(X2(:,3)));
K4 = kron(X1(:,4)',CrossOp(X2(:,4)));
%each Ki gives 2 lin independend exuation: 2*4 = 8 equations, this is all
%we need.. as we have 9 parameters, but one is overall scale(constant..)..
%so we need 8 parameter.. = 4 points

B=[K1;K2;K3;K4];
[u,s,v]=svd(B);
H=v(:,end); %=H, where min(BH) is minimal.
H = reshape(H,[3,3]);

figure
%Note That H has to be transposed here if column vectors are used for poin
Tr=maketform('projective',H');
% XData and YData need to be specified to get the output coordinate system
WarpIm=imtransform(Im,Tr,'YData',[0 13.4],'XData',[0 6.1],'Size',size(Im));
imagesc(WarpIm,'YData',[0 13.4],'XData',[0 6.1])