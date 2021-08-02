function inliners = consensus( l, points, T )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
inliners =0;
sizeOfPoints = (size(points));
for i=1:sizeOfPoints(2)
    isBelowTreshold = isInliers(T,[points(:,i);1],l);
    if (isInliers(T,[points(:,i);1],l))
        inliners=inliners+1;
    end
end
end


