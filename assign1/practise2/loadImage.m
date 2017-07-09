%Read the image
orimg=imread('Balloon.tif');
%red image
r1=orimg;
r1(:,:,2:3)=0;
figure
imshow(r1)
%green image
g1=orimg;
g1(:,:,[1 3])=0;
figure
imshow(g1)
%blue image
b1=orimg;
b1(:,:,1:2)=0;
figure
imshow(b1)
%image size
size(orimg)
%memory size of image
whos orimg
%resize image
modifiedimg = imresize(orimg ,0.5);
%save as new image.
imwrite(modifiedimg,'smallImage.tif');
figure
imshow(modifiedimg)
%change the colors 
modiImg(:,:,2)= orimg(:,:,1);
modiImg(:,:,3)= orimg(:,:,2);
modiImg(:,:,1)= orimg(:,:,3);

figure
imshow(modiImg)
