function [idx,rho] = CornerXCorr(p, corners2, im1, im2, n)

p1 = ExtractImgPatch(im1, p, n);
if any(p1(:))
    rho = -Inf;
    for i = 1:size(corners2, 1)
        p2 = ExtractImgPatch(im2, corners2(i, :), n);
        
        p1 = double(p1(:));
        p2 = double(p2(:));

        
        cc = cov(p1, p2);
        if isnan(cc)
            continue
        end
        rho_temp = cc(1,2) / sqrt(cc(1,1) * cc(2,2));
        
        if rho_temp > rho
            rho = rho_temp;
            idx = i;
        end
    end
else
    % If the patch is invalid return nan. 
    rho = nan;
    idx = nan;
end