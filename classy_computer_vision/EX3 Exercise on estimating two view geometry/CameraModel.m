%Q1.1 setting up camera 
t1=[0 0 0]';
t2=[-5 0 2]';
t3=[0.1 0 0.1]';
R = eye(3);
%A=eye(3), is assumed to be applied.
P1=[R,t1];
P2=[R,t2];
P3=[R,t3];

Q1=[2 4 10 1]';
%3D point n on image of camera m = q_nm
q11=P1*Q1; 
q12=P2*Q1;
q13=P3*Q1;

q11=q11./q11(3);
q12=q12./q12(3);
q13=q13./q13(3);
%verbal explanation: C1 at origin, C2 to the -5 left of it and 2 forward,
%C3 almost at same point as C1.. 

%Q1.2 3D solver:
Q = Est3D(q11,P1,q13,P3);
Q=Q./Q(4); % this is the same as before, so our function works
normOfQ = norm(Q); %==1

%Q1.2.1 given q21,q22, find Q2  ??? is this correct?
q21=[-0.1667 0.3333 1]';
q22=[-0.5 0.2857 1]';
Q2 = Est3D(q21,P1,q22,P2);
Q2=Q2./Q2(4); % to get inhomogeneous coordinate
normOfQ2 = norm(Q2); %==1

%Q1.2.2 projection of estimated Q2 into image plane 3.
q23 = P3*Q2; 

%Q1.3 Accuracy, here we add noise
%Q1.3.1 add permutation
permutation = 0.1*[1 1 1]';
q22_per= q22 + permutation;
q23_per= q23 + permutation;
%Q1.3.2 Reestimate Q2 via q21,q22_per
Q2_est_1= Est3D(q21,P1,q22_per,P2);
Q2_est_1=Q2_est_1./Q2_est_1(4);

%Q1.3.3 Reestimate Q2 via q21,q23_per
%here whe should get a greater error, as camera 1 and 3 are very close to
%each other.. so a small error, leads to a big move in intersection point.
%??? what should i exactly see here?
Q2_est_2= Est3D(q21,P1,q23_per,P3);
Q2_est_2=Q2_est_2./Q2_est_2(4);

%Q1.3.4 
%here whe should get a greater error, as camera 1 and 3 are very close to
%each other.. so a small error, leads to a big move in intersection point.
%??? what should i exactly see here?
error1= Q2-Q2_est_1;
NormError1=norm(error1)

error2= Q2-Q2_est_2;
NormError2=norm(error2)

%Q1.4 What exactly should i do here? isn't it just the same as above?


