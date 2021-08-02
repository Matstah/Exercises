function F = Fest_8point(q1,q2)
%given 8 points, estimate the fundamental matrix.
%   we assume that each correspondance satisfies qr(i)'*F*ql(i)=0
%   F=3x3, 1 is scale, so 8 unknowns..unlike to homography, each point
%   corresponds to one line (not one point), so we need at least 8 lines=8
%   points.
%qr(i)'*F*ql(i)=0=bi'*vec(F)...bi = kröonecker product ect..
B=[];
for i=1:length(q1)
    b1 = kron(q2(:,i)', CrossOp(q1(:,i)));%this is wrong.. it is homography...
    %b= one line... do hardcode..
    B=[B;b1];
end
%what does this do exactly???
%[U,S,V] = svd(B); %B=USV = WLW^-1  
%F=V(:,end);
%F = reshape(F,[3,3])'; %??? could i not just take U?

points1 = cornerPoints(q1(1:2,:)');
points2 = cornerPoints(q2(1:2,:)');
F = estimateFundamentalMatrix(points1,points2);

end

