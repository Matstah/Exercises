function p = ExtractImgPatch(im,p,n)
if (p(1)-n)<=0 || (p(1)+n) > size(im,2) || (p(2)-n)<=0 || (p(2)+n) > size(im,1)
    p = zeros(2*n+1);
else
    p = im(p(2)-n:p(2)+n,p(1)-n:p(1)+n); %vector
end
