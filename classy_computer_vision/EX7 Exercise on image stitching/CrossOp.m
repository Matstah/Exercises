function y = CrossOp(x)
%Takes 3dim vector x and returns 3x3 cross product matrix back
%   Detailed explanation goes here

y=[0 -x(3) x(2); x(3) 0 -x(1); -x(2) x(1) 0];

end

