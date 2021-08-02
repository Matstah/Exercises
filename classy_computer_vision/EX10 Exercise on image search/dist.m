function d = dist( v1,v2 )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
d=0;  
for i=1:length(v1)
      sum = (v1(i) + v2(i));
      if sum == 0
          d=d+0;
      else
      d=d+ (v1(i) - v2(i))^2/sum;
      end
end

end

