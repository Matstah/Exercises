% Calculates the distance between two HOG.
% loc, is the location of the sliding window on the fullhog. 
% fullhog, is the HOG of the full image
% hogcompare, is the HOG to search for
% wsize, is the size of the window extracted from fullhog (preferabl same
% size as hogcompare).
%
% stet, Technical University of Denmark, 06-05-2016.


function [ score ] = compareHog( loc, hogfull, hogcompare, wsize )

% Prevent Window from sliding over the bottom-edge
if loc(1) > size(hogfull,1)-wsize
    loc(1) = size(hogfull,1)-wsize;
end

% Prevent Window from sliding over the right-edge
if loc(2) > size(hogfull,2)-wsize
    loc(2) = size(hogfull,2)-wsize;
end

% Grab window from hogfull
window = hogfull(loc(1):loc(1)+wsize-1,loc(2):loc(2)+wsize-1,:);
% Calculate distance score
score = pdist2(window(:)',hogcompare(:)');

end

