function Q = Est3D(q1,P1,q2,P2)
% Returns estimated 3D point Q based on two image points q1,q2 (inhomo). 
%q1,q2 are projected 3D points onto images of 2 cameras. P1,P2 define
% cameras. 

%we know q1=P1*Q. so we need something like Q=inv(P1)*q1

%Point triangulation by finding intersection of two 3D lines (no noise)
% ??? is there a better methode? something in matrix form?
l1= P1(3,:)*q1(1) -P1(1,:);
l2= P1(3,:)*q1(2) -P1(2,:);

l3= P2(3,:)*q2(1) -P2(1,:);
l4= P2(3,:)*q2(2) -P2(2,:);
B=[l1; l2; l3; l4];

% solve least square problem, as we want Q argmin |BQ|^2
%from skript:

[u,s,v]=svd(B);
Q=v(:,end);

end

