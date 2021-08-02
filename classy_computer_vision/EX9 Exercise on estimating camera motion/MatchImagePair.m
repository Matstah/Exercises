function [M12,E,R,t] = MatchImagePair(F1,D1,F2,D2,K,Sigma)
%UNTITLED4 Summary of this function goes here
%     M12= matches(2xN), E=estimation of essential matrix, R = rotation, t=translation between two cameras 

%% a)compute the matches
[matches, scores] = vl_ubcmatch(D1, D2); %score= square eucledian distance
nMatch=size(matches,2);

%% b) Extract matchind 2D feature points & and put 2D points into normalized homogeneous coordinates
x1 = F1(1,matches(1,:));  %F1=[X;Y;S;TH]
y1 = F1(2,matches(1,:));
x2 = F2(1,matches(2,:));
y2 = F2(2,matches(2,:));
q1 = [x1;y1;ones(size(x1))]; %points in normalized homogeneous coordinates
q2 = [x2;y2;ones(size(x2))];

%% c) Use given funciton.
[E,R,t,nIn]=Eest(K,q1,q2,Sigma);

%% d) Form the fundamental matrix
F=inv(K)'*E*inv(K);
F=F./F(3,3);
%and compute which matches are consistent with the found 
%epipolar geometry using the Sampsons distance. 
%FIND all inliners... and only use them..
M12 = [];
dist = zeros(1,nMatch);
for i=1:nMatch
    dist(i)=FSampDist(F,q2(:,i),q1(:,i));
end
med = median(dist);
for i=1:nMatch
    if (dist(i)<med) %(FSampDist(F,q1(:,i),q2(:,i))<3.84*4^2)
        M12 = [M12,[matches(1,i); matches(2,i)]]; % return m12, containing pairs of indices for matches 
    end
end  
end
