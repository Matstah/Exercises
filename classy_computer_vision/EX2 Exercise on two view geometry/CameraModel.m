%given from Ex1:
clear
close all
Q=Box3D;
plot3(Q(1,:),Q(2,:),Q(3,:),'.'),
axis equal
axis([-1 1 -1 1 -1 5])
xlabel('x')
ylabel('y')
zlabel('z')


%Camera Model:
%External:
R= Rot(0.2,-0.3,0.1);
t=[0.8866 0.5694 0.1911]';
%internal:
f=1000;
dx = 300;
dy = 200;
A=[f 0 dx; 0 f dy; 0 0 1];

%add radial distortion:
    %this bows edges a little, depending on radius.. why is it bend inwords
    %and not outwords, as error should get bigger with greater radious?
    %what is the difference between 2 and 3? i guess the error.. is my view
    %the image plane, and i correct the error, or i modle the error.. so
    %what i see, is it what i should transform the image to, or it shows
    %what my image is?
k3=-10^(-6);
k5=0;
%k5=10^(-12);
Ap=[f 0 0; 0 f 0; 0 0 1];
Aq=[1 0 dx; 0 1 dy; 0 0 1];

Pp= Ap*[R t];
q=Pp*[Q;ones(1,size(Q,2))];%distorted projection coordinates/ homogeneous

q(1,:)=q(1,:)./q(3,:); %all x coordinates
q(2,:)=q(2,:)./q(3,:); %all y coordinates
q(3,:)=q(3,:)./q(3,:); %=1=s / %now q inhomogeneous
r = q(1,:).^2 + q(2,:).^2; %r=xi^2+yi^2/ r=1xn 
dr=k3*r + k5*r.^2; %error= k3*r^2 +k5^4 
dr = [dr ; dr];
pc = q(1:2,:).*(ones(2,length(q(1,:))) + dr );

figure
q=Aq*[pc;ones(1,size(pc,2))];
q(1,:)=q(1,:)./q(3,:);
q(2,:)=q(2,:)./q(3,:);
q(3,:)=q(3,:)./q(3,:);
plot(q(1,:),q(2,:),'.')
axis equal
axis([0 640 0 480])


%my conclusion: assume only k3!=0. when if k3<0 we have a fish eye vies, as
%we subtract more, when we are further away.. when k3>, we have a
%pincushion distortion. Test k3 positive and negative..