function dist=FSampDist(F,p1,p2)
%UNTITLED3 Summary of this function goes here
%   what we have is q2'Fq1=e

nom = (p2'*F*p1)^2;
q1 = F*p1;
q2 = p2'*F;
denom = q1(1)^2 + q1(2)^2 + q2(1)^2 + q2(2)^2;
dist = nom/denom;
end

