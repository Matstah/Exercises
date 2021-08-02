function patch = extractPixelPatch(Im,x,y,n)
%Returns a (2n+1)*(2n+1) pixel patch around (x,y)
%   why 2n+1: because we want (x,y) to be in the middle of one side.
%   if (x,y) is not at least n pixels away from the border, return a patch
%   of all zeros: not usefull patch..

zeroPatch = zeros(2*n+1,2*n+1);

%check if patch is within our image
if(x<=n || (size(Im,2)-n <=x)) 
    patch = zeroPatch;
    return
end
if(y<=n || (size(Im,1)-n <=y)) 
    patch = zeroPatch;
    return
end

%get patch from image size (2n+1)*(2n+1)
x = int32(x);
y = int32(y);
patch = Im(y-n:y+n, x-n:x+n);% im=[y,x]=[rows,columns] %submatrix = fullMatrix(row1:row2, column1:column2);
        % could also use someting like imcrop(Im, [Ystart, Xstart, n, n])
end

