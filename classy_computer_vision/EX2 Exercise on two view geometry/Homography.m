clear all; clc;
%Q14 get points in 3D. Q= aA + bB + C
Q=PointsInPlane();

%camera model from Q1:
%External:
R= Rot(0.2,-0.3,0.1);
t=[0.8866 0.5694 0.1911]';
%internal:
f=1000;
dx = 300;
dy = 200;
A=[f 0 dx; 0 f dy; 0 0 1];

P=A*[R,t]; %Q14

%Q15 compute the homography
A = [1/sqrt(2); 0; 1/sqrt(2)];
B = [0; 1; 0];
C = [1; 0.5; 5];
H = P*[A B C; 0 0 1];

%plot
figure('Name','Camera image')
q=P*[Q;ones(1,size(Q,2))]; %is this correct? isn't P*Q enough? no, need 1's for plane equation
q1(1,:)=q(1,:)./q(3,:);
q1(2,:)=q(2,:)./q(3,:);
q1(3,:)=q(3,:)./q(3,:);
plot(q1(1,:),q1(2,:),'.')
axis equal
axis([0 640 0 480])

%Q16.. ?? is this the correct answer? it is almost the same.. i think that
%due to big to small numbers, and no warp, the backtransformed image is not
%exact.
% ??? why do i not get a correct answer if i work with inhomogeneous
% coordinater... where do i have homogeneous, and where not? something is
% weard..
figure('Name','View after Homography applied')
q2 =H\q; 
plot(q2(1,:),q2(2,:),'.')
%axis equal
%axis([0 640 0 480])
