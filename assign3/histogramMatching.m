function histoMatchedImg = histogramMatching(iMat1,iMat2)
if size(iMat1,3)==3
    %Convert color image to grayscale
    iMat1=rgb2gray(iMat1);
elseif size(iMat2,3)==3
    iMat2=rgb2gray(iMat2);
end
%Histogram matching function histogram match Img iMat2 with iMat1.
histoMatchedImg = imhistmatch(iMat2,iMat1);

figure
subplot(2,2,1);
imshow(iMat2);
title('Input img');

subplot(2,2,2);
imshow(histoMatchedImg);
title('output1');
%Displaying the Histograms of the input image and the result image.
figure
subplot(2,2,1);
imhist(iMat2);
title('Img to change');
subplot(2,2,2);
imhist(iMat1);
title('Reference Img hist');
subplot(2,2,3:4);
imhist(histoMatchedImg);
title('output img hist');
end
