function mov = makeVideo( cell1 )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

for i=1:length(cell1)
    mov(i) = im2frame(cell1{i});
end

end

