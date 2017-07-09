ballonImg = imread('Balloon.tif');
lenaImg = imread('LenaGray.tif');
%
%Use histeq as starting point
startPointImg = histeq(lenaImg);
figure
subplot(1,2,1);
imshow(startPointImg);
title('Start point Image');
subplot(1,2,2);
imhist(startPointImg);
title('histogram');

%histogram match for imat1 with imat2
histoMatchedImg=histogramMatching(ballonImg,lenaImg);
%saving the matched image as output1.jpeg
imwrite(histoMatchedImg,'output1.jpg');
iMat1=ballonImg;
iMat2=lenaImg;
if size(iMat1,3)==3
    %Convert color image to grayscale
    iMat1=rgb2gray(iMat1);
elseif size(iMat2,3)==3
    iMat2=rgb2gray(iMat2);
end
%buildin function hough as the starting point.
bw = edge(iMat1,'canny');
%hough for a particular radius
H= hough(bw);
figure,
subplot(1,2,1);
imshow(iMat1);
subplot(1,2,2);
imshow(imadjust(mat2gray(H)),...
    'InitialMagnification','fit');
axis on,
axis normal;
title('Hough start point');
colormap(gca,hot);
%Given radius
prompt = 'What is the radius value?(values > 6) (ex: 60)';
radius = input(prompt);

%checking radius default radius to 30
if radius<0
    di='Entered radius  %d is not accepted taking default value 30. ';
    fprintf(di,radius);
    radius=30;
end

%Function to find the cricles of specified radius
image = findCircles(ballonImg,radius);
imwrite(image,'output2.jpg');
img=findCircles(lenaImg,radius);
imwrite(img,'output3.jpg');
