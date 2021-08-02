%Q1 make function that estimates a line given two points
%p1 =[1,1,1]';
%p2 = [0,0,1]';
%l = estimateLine(p1,p2); %l=[a,b,c] => 0=ax+by+c
%Q2 check if point is close to line
%T=1;
%isInliers(T,[2,0,1]',l)


%Q4 draw two random points on image
In=50;
Out=30;
X=RanLine(In,Out);
T=1;

%Q4randomly pick 2 points out of n=X
%[rp1,rp2] =  pick2points(X);

%Q3 given a line and a treshold, 
%numOfAccepted = consensus( l, points, T );

%Q5 make a working Ransac function
%so we have n points, and we try N times
N=100;
[rp1,rp2]= pick2points(X); 
l = estimateLine([rp1;1],[rp2;1]);
LineWithMostVotes=l;
numberOfMaxVotes= consensus( l, X, T );
for i=2:N
    [rp1,rp2]= pick2points(X); 
    l = estimateLine([rp1;1],[rp2;1]);
    votes =consensus(l,X,T);
    if votes>numberOfMaxVotes
        LineWithMostVotes=l;
        numberOfMaxVotes= consensus( l, X, T );
    end
end
LineWithMostVotes
numberOfMaxVotes
figure('name', 'lineDrawn')
%plot(X,'x');
%hold on
scatter(X(1,:),X(2,:));
hold on;
DrawLine(LineWithMostVotes);



