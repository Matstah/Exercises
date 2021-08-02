im = imread('dturoad1.jpg');
im2 = imread('dturoad2.jpg');

%% Q1 Simple Sliding Window

im = imresize(im,[240 320]); % set size of image
%Q4
imobj = imread('sign1_64.jpg');
imobjhsv = rgb2hsv(imobj);
%save hsit Q4
imobjHistH = imhist(imobjhsv(:,:,1));
imobjHistS = imhist(imobjhsv(:,:,2));
imobjHistV = imhist(imobjhsv(:,:,3));
%plot hist Q5 %it explains if something has the same color, even if it does
%not have the same lightning conditions.. 
figure('name', 'histogram object'), hold on,
imhist(imobjhsv(:,:,1)); %H = color
imhist(imobjhsv(:,:,2)); %S = saturation = how much white is added..(low saturation = white)
imhist(imobjhsv(:,:,3)); %V = value = amplitude of the light (no light = dark)
%Q6
h_hist = histcounts(imobjhsv(:,:,1),256);
h_hist = h_hist/sum(h_hist);
figure('name', 'hist plot')
plot(h_hist)

figure; imagesc(im); hold on; 
wsize = [size(imobj,1), size(imobj,2)]; %windowsize, make same size as imobj we are looking for. 
stepx = 5; %stepsize x−direction 
stepy = 5; %stepsize y−direction
dist = 100;
dist2 = 100;
dist3 = 200;
x = 0;
y = 0;
x2 =0;
y2 =0;
x3 =0;
y3 =0;
%%
for col = 1:stepy:(size(im,1)-wsize(1))
    for row = 1:stepx:(size(im,2)-wsize(2))   
        % draw a rectangle on the image:
        rectangle('Position',[row col wsize(1) wsize(2)],'EdgeColor','r','LineWidth',2);
        %Q3 takes out one patch
        window = im(col:col+wsize(2),row:row+wsize(1),:);
        %imshow(window);
        patchhsv = rgb2hsv(window);
        h_patch = histcounts(patchhsv(:,:,1),256);
        h_patch = h_patch/sum(h_patch);
        D = pdist2(h_hist,h_patch);
        if D < dist
            dist = D;
            x=col;
            y=row;
        end
        if D> dist && D<dist2
            dist2 = D;
            x2 =col;
            y2 = row;
        end
        if D> dist2 && D<dist3
            dist3 = D;
            x3 =col;
            y3 = row;
        end
        % wait for keypress :
        %pause
        %pause(0.001)
    end
end
figure('name', 'best match')
imagesc(im); hold on;
rectangle('Position',[y x wsize(1) wsize(2)],'EdgeColor','r','LineWidth',2);
rectangle('Position',[y2 x2 wsize(1) wsize(2)],'EdgeColor','black','LineWidth',2);
rectangle('Position',[y3 x3 wsize(1) wsize(2)],'EdgeColor','b','LineWidth',2);
%so the match is kind of shitty, because we just take the best match with
%regards to the color histogram.. nothing related to the shape of an
%object..







