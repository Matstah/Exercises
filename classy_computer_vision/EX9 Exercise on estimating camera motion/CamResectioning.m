function cameraModel = CamResectioning(p,Q)
% Q8: Calculating pinhole camera model given 6 2D-3D points.
%p=2D point on image plane == Q=3Dpoint corresponding to same point
% q(i) = P*Q(i), as both are vectors going  into same direction,
% q(i)crossProductP*Q(i)==.. so use b(i)'*vec(P)=0... take min B.. Page 54
assert(length(p)==length(Q));
assert(length(p)>=6);
B=[];
for i=1:size(p,2)
    %l1 = [0, -Q(1,i), p(2,i)*Q(1,i), 0, -Q(2,i), p(2,i)*Q(2,i), 0, -Q(3,i), p(2,i)*Q(3,i), 0, -1, p(2,i)];
    %l2 = [Q(1,i), 0, -p(1,i)*Q(1,i), Q(2,i), 0, -p(1,i)*Q(2,i), Q(3,i), 0, -p(1,i)*Q(3,i), 1, 0, -p(1,i)];
    %l3 = [-p(2,i)*Q(1,i), p(1,i)*Q(1,i), 0, -p(2,i)*Q(2,i), p(1,i)*Q(2,i), 0, -p(2,i)*Q(3,i), p(1,i)*Q(3,i), 0, -p(2,i), p(1,i), 0];
    %B = [B; l1; l2; l3];
    b = [0 -p(3,i) p(2,i); p(3,i) 0 -p(1,i); -p(2,i) p(1,i) 0];
    k = kron(Q(:,i)',b);
    B = [B;k];
end

[U,S,V] = svd(B);
p=V(:,end); % end means we have the min value.. as S(end,end) is the smallest EValue
p = reshape(p,[3,4]);
cameraModel=p./p(3,4);