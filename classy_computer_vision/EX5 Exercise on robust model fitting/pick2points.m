function [ p1, p2 ] = pick2points( X )
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
i = randi(size(X(1,:)));
p1= X(:,i);
i = randi(size(X(1,:)));
p2= X(:,i);

end

