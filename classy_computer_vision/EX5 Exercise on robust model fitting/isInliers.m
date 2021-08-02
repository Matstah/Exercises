function inLiers = isInliers( T, p, l)
% checks if a point is within the treshold to a line
n = norm(l(1:2));
l(1:2)=l(1:2)./n;
dist = abs(dot(l,p));
inLiers= dist<T;
end

