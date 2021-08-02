%set up cameras
A=[100 0 300; 0 1000 200; 0 0 1];
t=[0.2 2 0.1]';
R= Rot(-0.1,0.1,0);

Pcam1 = A*[eye(3), zeros(3,1)];
Pcam2 = A*[R,t];

Q=[1 0.5 4 1]';

%Q5: are these coordinates correct?
q1= Pcam1*Q;
q2= Pcam2*Q;

%Q6: computation of fundamental matrix / x = A\b better than x = inv(A)*b
F=inv(A)'*CrossOp(t)*R*inv(A); 
% ???is there any better way numerically?
% am i right that there is only one Fundamental matrix, as only 2 cams..
% n-1 fundamental matrix for n cameras? all relate to one?

%Q7: find the epipolar line for camera 2:
line = F*q1;

%Q8: is q2 on the epipolar light? 
%due to numerical issues, cannot direclty check ==0..
%this must be true, as "line" is the line in image two, given the
%projection (from known image point) in image two.. 
% ??? or what should be seen here?
checkZero = abs(q2'*line);
if(checkZero<exp(-1))
    1
else
    0
end




