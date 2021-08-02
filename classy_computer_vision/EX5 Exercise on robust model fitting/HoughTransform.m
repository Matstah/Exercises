%Q1 different edge filters get different noice level
im = imread('BookImage.jpg');
im = rgb2gray(im);
imshow(im);


BW = edge(im, 'Canny'); 
%BW = edge(im, 'Sobel');
%BW = edge(im, 'Prewitt');
figure('name', 'edge');
imshow(BW);

%Q2
[H, T, R] = hough(BW);
%Q3
figure('name', ' hough space')
imagesc((H));

%Q4
H2=H/max(H(:)); %sets the highes value of the Hough matrix to one.
H2=H2.^0.5;

%Q5
numpeaks= 10;
P = houghpeaks(H,numpeaks);
%RGB = insertMarker(H,peaks);
figure('name', 'marked highest peaks') 
imshow(H,[],'Xdata', T,'YData',R,'InitialMagnification','fit')
hold on, axis on, axis normal
x = T(P(:,2)); y = R(P(:,1));
plot(x,y,'s','color','red');

%Q6 

[row, column] = size(im);
figure('name','lines shown')
imshow(im);
hold on
for i=1:size(P(:,1))
    l=[cosd(T(P(i,2))), sind(T(P(i,2))), -R(P(i,1))];
    DrawImageLine(row, column, l);
    
end






