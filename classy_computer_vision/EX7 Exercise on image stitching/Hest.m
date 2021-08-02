function H = Hest( X1,X2 )
%Function that estimates homography from two point pairs
%   X1 = H*X2

%use nomral coordinates
X1 = X1./X1(3,:);
X2 = X2./X2(3,:);

K=[];
for i=1:min(size(X1,2),size(X2,2))
    K1 = kron(X1(:,i)',CrossOp(X2(:,i)));
    K = [K;K1];
end
[U,S,V] = svd(K);
H=V(:,end);
H = reshape(H,[3,3]);

end

