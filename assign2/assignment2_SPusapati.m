%Run this program file assignment2_spusapati.m 
%It generates all the required channels and size values accordingly.
%read the image
ballonImg = imread('Balloon.tif');

%Displaying the image
figure
imshow(ballonImg);
title("Original Image");

%Convert the image into HSV image
hsvImg = rgb2hsv(ballonImg);
figure
imshow(hsvImg);
title("HSV IMAGE");

%HSV display each channel seperately
hue = hsvImg(:, :, 1); % Hue image.
figure
imshow(hue);
title("Hue image");

saturation = hsvImg(:,:,2); %Saturation Image
figure
imshow(saturation);
title("Saturation image");

valueIntensity = hsvImg(:, :, 3); % Value Intensity image.
figure
imshow(valueIntensity);
title("Value Intensity image");

%color image into YCrCb
yCrCbImg = rgb2ycbcr(ballonImg);
figure
imshow(yCrCbImg);
title("YCrCb Image");

%YCRCB display each channel separately
yComponent=yCrCbImg(:,:,1);%Y channel
figure
imshow(yComponent);
title("Y component");

%Cr channel
crChannel=yCrCbImg(:,:,2);
figure
imshow(crChannel);
title("Cr Channel");

%Cb channel
cbChannel=yCrCbImg(:,:,3);
figure
imshow(cbChannel);
title("Cb Channel");

%Converting to Grayscale Image
grayImg = rgb2gray(ballonImg);
figure
imshow(grayImg);
title("Grayscale Image");
imageSize=size(grayImg)

%enlarge the image by 4 times
figure
bigImg=imresize(grayImg,4);
imshow(bigImg);
title("Resized image");
bigImgSize = size(bigImg)

%Crop the image to original size
figure
origImg = imcrop(bigImg,[511,511,511,511]);
%creating an image handle
imgHandle=imshow(origImg);
title("croped image");

% Display the image size
imgSize = size(origImg)
%creating an image model for calculating the intensity values.
imgModel = getimagemodel(imgHandle);

%minimum intensity
minIntensity = getMinIntensity(imgModel);
display(minIntensity);

%maximum intensity.
maxIntensity = getMaxIntensity(imgModel);
display(maxIntensity);

%average Intensity using the mean option.
avgIntensity = mean2(origImg);
display(avgIntensity);

%saving the image into a file named "output.jpg"
imwrite(origImg,'output.jpg')
