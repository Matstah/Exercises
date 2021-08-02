Im = imread('petergade.png');
%imshow(im);
%[x,y]=ginput(5); % picks one point
%left down, left up, right up, right down, down middle middle:
a=[0, 13.4, 13.4, 0, 4.75]; 
b=[0, 0, 6.1, 6.1, 3.05];
x = [57.6620320855615, 61.0951871657754, 209.407486631016, 269.144385026738, 151.730481283422];
y = [223.322994652406, 68.8310160427808, 66.7711229946524, 217.143315508021, 153.973262032086];
X1 = [x; y; ones(1,length(x))];
X2=[a; b; ones(1,length(a))];
%we want to project from 2D plane to 2D plane. So our H must be 3x3. also H
%must be linearly independend, such that it can be inverted, and map each
%point exact.... H has 3x3=9 unknowns. Each point gives us 2 equations..
%need 5 points that are the same in reality!






%normalize coordinates
%set up B matrix
b = @(i) kron(X2(:,i)' , CrossOp(X1(:,i)));  
B= [b(1); b(2); b(3); b(4)];
%minimize and get H matrix
[u,s,v]=svd(B);
vecH=v(:,end);
H = vec2mat(vecH,3);

figure
%Note That H has to be transposed here if column vectors are used for poin
Tr=maketform('projective',H');
% XData and YData need to be specified to get the output coordinate system
WarpIm=imtransform(Im,Tr,'YData',[0 q(2,3)],'XData',[0 q(1,6)]);
imagesc(WarpIm)