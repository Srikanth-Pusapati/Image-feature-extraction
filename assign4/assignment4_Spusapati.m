%Execute this file for the outputs.
%Load image
img = imread('Balloon.tif');
noimg = imnoise(img,'speckle');
%Displaying the original and speckle noise images
figure,
subplot(1,2,1);
imshow(img);
title('Original');
subplot(1,2,2);
imshow(noimg);
title('Distorted');
%distortedImg =speckleNoise(img);
%Function to add medianFilter
%filterdImg=medianFilter(distortedImg,img);
%function to add Guassian noise
%gaussianNoiseImg=gaussianNoise(img);

%remove noise and display the result image
%removeNoise(gaussianNoiseImg);

%sobel & canny edge detection
%sobelCanny(img);
%gaussian filter and unsharp the image.
%gaussianAvgFilt(img);

% function noiseImg = speckleNoise(img)
% %Function to add speckle noise
% noiseImg = imnoise(img,'speckle');
% %Displaying the original and speckle noise images
% figure,
% subplot(1,2,1);
% imshow(img);
% title('Original Image');
% subplot(1,2,2);
% imshow(noiseImg);
% title('Distorted Image');
% end



% function filterdImg=medianFilter(noiseImg,originalImg)
%Function to add median filter
medimg=medfilt3(noimg);

figure,
subplot(1,2,1);
imshow(noimg);
title('Noise');
subplot(1,2,2);
imshow(medimg);
title('Filtered Image');

dif=imabsdiff(img,medimg);
figure,
imshow(dif);
title('Difference');


gimg=imnoise(img,'gaussian');

figure,
subplot(121);
imshow(img);
title('Original');
subplot(122);
imshow(gimg);
title('Gaussian ');


function [] = removeNoise(gimg)
noiseRemovedImg = imgaussfilt3(gimg);%Applying gaussian filter
% h= fspecial('gaussian');
% noiseRemovedImg = imfilter(noiseImg, h);
figure,
imshow(noiseRemovedImg);
title('Filtered Image');
end


function []=sobelCanny(balloonImg)
%Sobel and Canny edge detector to the original image and display the results
grayBalloon=rgb2gray(balloonImg);
[~,threshold]=edge(grayBalloon,'sobel');
%Using different threshold values.
for fx =0.3:0.3:1
    t=threshold*fx;%single element vector
    sobel=edge(grayBalloon,'sobel',t);
    figure,
    imshow(sobel,...
        'InitialMagnification','fit');
    title(['sobel threshold is ',num2str(t)]);    
end

[~,threshold]=edge(grayBalloon,'canny');
for fx =0.3:0.3:1
    t1=threshold*fx; %two-element vector
    cannyImg=edge(grayBalloon,'canny',t1);
    figure,
    imshow(cannyImg,...
        'InitialMagnification','fit');
    title(['canny threshold is ',num2str(t1)]);    
end

end


function [] = gaussianAvgFilt(oriImg)
%3x3 Gaussian average filter
avg=fspecial('average',[3 3]);
avgFilt=imfilter(oriImg,avg);
gausFilt=imgaussfilt3(avgFilt);
%unsharp mask filter to enhance the smoothed image
sharpImg=imsharpen(gausFilt);
%Displaying the smoothed and enhanced images
figure,
subplot(1,2,1);
imshow(gausFilt);
title('smoothed image');
subplot(1,2,2);
imshow(sharpImg);
title('enhanced image');
end
