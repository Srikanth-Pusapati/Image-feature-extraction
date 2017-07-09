clear;
close all;
%Load image 'Balloon.tif' and convert it into a grayscale image,
%denoted with 'img1'

ballonImg = imread('Balloon.tif');
img1=rgb2gray(ballonImg);
figure,
imshow(img1);
title('Original Image');
%Fourier transform to img1
ffImg=fft2(img1);
ffShift=fftshift(ffImg);
phase=angle(ffShift);
ampl=abs(ffShift);
%display the amplitude and phase matrices
figure,
subplot(1,2,1);
imshow(uint8(ampl))
title('FFT Amplitude');
subplot(1,2,2);
imshow(phase);
title('FFT Phase');

[M, N]=size(ffImg); % image size
filterSize=10; % filter size parameter
xmeshGridVal=0:N-1;
ymeshGridVal=0:M-1;
[xmeshGridVal,ymeshGridVal]=meshgrid(xmeshGridVal,ymeshGridVal);
Cx=0.5*N;
Cy=0.5*M;
lowFilterVal=exp(-((xmeshGridVal-Cx).^2+(ymeshGridVal-Cy).^2)./(2*filterSize).^2);
% lowFilterVal = fspecial('gaussian',[M, N],10);
%Gaussian lowpass filter, apply it to the Fourier coefficients
lfiltVal=ffShift.*lowFilterVal;
%inverse Fourier transform using ifft
inverslFilt=ifft2(ifftshift(lfiltVal));
figure,
imshow(abs(inverslFilt),[]),colormap gray
title('low pass image');

%Gaussian highpass filter and apply it to the Fourier coefficients
highFilterVal=1-lowFilterVal;
highVal=ffShift.*highFilterVal;
%inverse Fourier transform to recover the filtered image
inverseffVal=ifft2(ifftshift(highVal));
figure,
imshow(abs(inverseffVal),[]), colormap gray
title('High pass filtered image');


% Decompose the original img1 with wavelet transform
% Can also use these lines of code
% [c,s]=wavedec2(img1,2,'haar');
% [H,V,D] = detcoef2('all',c,s,2);
% A = appcoef2(c,s,'haar',2);
[A,H,V,D]=dwt2(img1,'haar');
%need to rescale the values to be in the range of [0 255], taking default
%mat-matrix and 1
Vimg = wcodemat(V,255,'m',1);
Himg = wcodemat(H,255,'m',1);
Dimg = wcodemat(D,255,'m',1);
Aimg = wcodemat(A,255,'m',1);
%Display the wavelet coefficients as an image
figure,
subplot(2,2,1);
imagesc(Aimg);
colormap gray;
title('Approximation ');
subplot(2,2,2)
imagesc(Himg);
title('Horizontal detail ');
subplot(2,2,3)
imagesc(Vimg);
title('Vertical detail ');
subplot(2,2,4)
imagesc(Dimg);
title('Diagonal detail ');


%Reconstruct edge map with non zero
nonZeroEdgeMap=idwt2(A,H,V,D,'haar',size(img1));
%Reconstructed edge map with zero approx matrix
ZE=zeros(size(A));
zeroEdgeMap = idwt2(ZE,H,V,D,'haar',size(img1));
imwrite(zeroEdgeMap,'output.jpg');
figure,
imagesc(nonZeroEdgeMap),colormap gray,
title('Non Zero Edge');
figure,
colormap gray,
imshow(zeroEdgeMap);
title('Zero Edge');


m1=graycomatrix(zeroEdgeMap);%Zero approximation image
m2=graycomatrix(img1);%Original Image
%Homogeneity and Energy of images.
heImg=graycoprops(m1,{'Homogeneity','Energy'});
disp('Homogeneity,Energy of zero Edge Image');
disp(heImg);
nHeImg=graycoprops(m2,{'Homogeneity','Energy'});
disp('Homogeneity, Energy of Non zero Edge Image');
disp(nHeImg);
%Homogeneity difference
hmDiff=abs(heImg.Homogeneity-nHeImg.Homogeneity);
fprintf('Homogeneity difference is :%f\n',hmDiff);
%Energy Difference.
engDiff=abs(heImg.Energy-nHeImg.Energy);
fprintf('Energy difference is :%f\n',engDiff);
entZeImg=entropy(zeroEdgeMap);
fprintf('Entropy value of Zero Edge image is :%f\n',entZeImg);
entNonZerImg=entropy(img1);
fprintf('Entropy value of non zero edge image is :%f\n',entNonZerImg);
%Entropy difference
diffentropy=abs(entZeImg-entNonZerImg);
fprintf('Entropy difference is :%f\n',diffentropy);
