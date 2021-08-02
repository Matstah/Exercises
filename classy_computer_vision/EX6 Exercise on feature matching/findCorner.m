function [ I_col, I_row ] = findCorner( Im2, patch1 )
%find corner of given patch in an image
%   
%isnan()= we cont care..
n = (length(patch1)-1)/2;   %(2n+1) = length of patch.. want n

numRow = size(Im2,1);
numCol = size(Im2,2);
crossCorrMatrix = zeros(size(Im2));

%gives us all correlation values, each with one image lookup.
for Xi=n+1 : (numCol-n-1)
    for Yi=n+1 : (numRow-n-1)
        patch2 = extractPixelPatch(Im2,Xi,Yi,n);
        if not(isnan(patch2)) %to handle division by zero.. only happens on image edges, as we asume to always have noice.
            crossCorrMatrix(Yi,Xi) = crossCorrelation(patch1, patch2); %matrix(row,column)
        end
    end
end
[M,I] = max(crossCorrMatrix(:));
MaxCalue = M
[I_row, I_col] = ind2sub(size(crossCorrMatrix),I);
end

