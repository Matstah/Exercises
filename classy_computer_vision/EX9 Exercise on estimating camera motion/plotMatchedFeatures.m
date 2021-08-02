function plotMatchedFeatures(M12,F1,F2,Im1,Im2)
%


xa = F1(1,M12(1,:));
ya = F1(2,M12(1,:));
xb = F2(1,M12(2,:))+ size(Im1,2) ;
yb = F2(2,M12(2,:));
figure('name', 'matches')
clf;
imshow(cat(2, mat2gray(Im1), mat2gray(Im2)));
hold on ;
randm = randperm(length(xa),20);
%h = line([xa(randm) ; xb(randm)], [ya(randm) ; yb(randm)]) ;
h = line([xa ; xb], [ya ; yb]) ;
set(h,'linewidth', 0.01, 'color', 'c') ;
axis image off;

end

