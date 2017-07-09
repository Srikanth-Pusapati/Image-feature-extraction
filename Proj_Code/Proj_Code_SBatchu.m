clear all; 
close all;
RGB=imread('imageRGB.png');

img1=rgb2gray(RGB);
figure; imshow(img1);

% horizontol, vertical and diagnol details.
[xar, xhr ,xvr ,xdr] = dwt2(img1(:,:,1), 'db2');
[xag, xhg ,xvg ,xdg] = dwt2(img1(:,:,1), 'db2');
[xab, xhb ,xvb ,xdb] = dwt2(img1(:,:,1), 'db2');

img1ar(:,:,1) = xar; img1ar(:,:,2) = xag; img1ar(:,:,3) = xab;
img1hr(:,:,1) = xhr; img1hr(:,:,2) = xhg; img1hr(:,:,3) = xhb;
img1vr(:,:,1) = xvr; img1vr(:,:,2) = xvg; img1vr(:,:,3) = xvb;
img1dr(:,:,1) = xdr; img1dr(:,:,2) = xdg; img1dr(:,:,3) = xdb;

figure, imshow(img1ar/255);
figure, imshow(img1hr);
figure, imshow(img1vr);
figure, imshow(img1dr);
% this shows One Stem Decomposition.
x1 = [ img1ar*0.003; log10(img1hr)*0.3; log10(img1vr)*0.3; log10(img1dr)*0.3];
figure, imshow(x1);
% Zero padding mode.
clear global
dwtmode
dwtmode('per')

% this shows Two Step Decomposition.
[c,s] = wavedec2(img1,2,'db2');
% Reconstruction
a0 = waverec2(c,s,'db2');
a0 = edge(a0);
%Reconstructed Edged map image. 
figure, imshow(a0);
% Here is all four features.
gclm1 = graycomatrix(img1);
gclm1_prop = graycoprops(gclm1);
gclm1_prop
Entropy = entropy(img1)
% Doifference betwwen Edged map and Gray Scale image
imgz = im2double(a0);
%diff = imsubtract(img1, imgz); 
%figure, imshow(diff)
% Shape Distribution Function
Z = img1
O = histeq(Z);
subplot(2,2,1);
imshow( Z );
subplot(2,2,2);
imhist(Z)
subplot(2,2,3);
imshow( O );
subplot(2,2,4);
imhist(O)
I=imread('imageRGB.png');
I=rgb2gray(I);
I=imresize(I,[164 164]);
[N N]=size(I)
imshow(I)
I=im2double(I);
title('Original Image');


gamma=0.3;
psi=0;
theta=90;
bw=2.8;
lambda=3.8;
pi=180;


for x=1:161
     for y=1:161
         x_theta = I(x,y)*+cos(theta)+I(x,y)*+sin(theta);
         y_theta = I(x,y)*+sin(theta)+I(x,y)*+cos(theta);
         gb(x,y) = exp(-(x_theta.^2/2*bw^2+gamma^2*y_theta.^2/2*bw^2))*cos(2*pi/lambda*x_theta*psi);
     end
end
figure(2);
imshow(gb);
title('Filtered Image');
