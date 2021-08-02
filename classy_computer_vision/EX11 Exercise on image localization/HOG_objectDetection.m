%Q13
im = imread ('dturoad1.jpg');
im = imresize(im,[240 320]);
[ featureVector ,visualization] = extractHOGFeatures(im); 
imobj = imread('sign1_64.jpg');
[h_hist,visualization2] = extractHOGFeatures(imobj);
h_hist = histcounts(h_hist,9);
h_hist = h_hist./sum(h_hist);
%visualize HOG features
figure('name','HOG query image') ;
imagesc(im); hold on;
plot(visualization);

figure('name','HOG query object') ;
imagesc(imobj); hold on;
plot(visualization2);

%Q14: how large are the HOG cells? Default value is [8 8] cell. We see that because in the plot, the dot is at [4,4],  so rigth in the middle, summarizing all gradients 

%% Q15: sliding with HOG  
stepy = 10;
stepx = 10;
dist = 100;
x =0;
y=0;
wsize = [size(imobj,1), size(imobj,2)];
figure(); imagesc(im); hold on;
for col = 1:stepy:(size(im,1)-wsize(1))
    for row = 1:stepx:(size(im,2)-wsize(2))
        rectangle('Position',[row col wsize(1) wsize(2)],'EdgeColor','r','LineWidth',2);
        %Q3 takes out one patch
        window = im(col:col+wsize(2)-1,row:row+wsize(1)-1,:);
        imshow(window);
        features = extractHOGFeatures(window); %data for histogram
        h_patch = histcounts(features,9);  %180/9 =20.. use 9bin histogram
        h_patch = h_patch/sum(h_patch);
        D = pdist2(h_hist,h_patch);
        if D < dist
            dist = D;
            x=col;
            y=row;
        end
        %pause
    end
end
figure('name', 'best match')
imagesc(im); hold on;
rectangle('Position',[y x wsize(1) wsize(2)],'EdgeColor','r','LineWidth',2);

%Q15 : HOG matches more like shapes, there HSV just looks at how many
%collors are in common..


