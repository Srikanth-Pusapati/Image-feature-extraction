clear
% close all
clc;
% Read image
ori = imread('imageRGB.png');
figure,
imshow(ori);
title('Origina');
street1 = rgb2gray(ori);
% CC = bwconncomp(imbinarize(street1));
% numPixels = cellfun(@numel,CC.PixelIdxList);
% [biggest,idx] = max(numPixels);
% street1(CC.PixelIdxList{idx}) = 0;
% % Display image
% figure,
% gray(256);
% imshow(street1);

% Scale image
scaled=street1*1.2;
% image(scaled);

% Thresholding image
level=120;
bin = scaled>level;
figure,
imshow(bin);
title('Threshold image');

% Remove the noise
bin = bwareaopen(bin,500);
figure,
imshow(bin),
title('Noise removed image');

% Find the boundaries of objects
[B,L] = bwboundaries(bin,'noholes');

h = zeros(1, length(B));
figure,
imshow(bin),
title('boundaries');
hold on;
% Plot boundaries
for K=1:length(B)
    boundary = B{K};
    h(K)=plot(boundary(:,2), boundary(:,1), 'r', 'LineWidth', 1);
end

% Extract statistics
stats = regionprops(L,'MajorAxisLength','MinorAxisLength','Area');

% Find roofs and delete non-building objects
roofs = findBuildings(B,h,stats);
hold off;

% Place roofs on original image
figure,
imshow(ori);
hold on;
for K = 1:length(roofs)
    if size(roofs{K})~=1
        plot(roofs{K}(:,2), roofs{K}(:,1), 'r', 'LineWidth', 1);
    end
end
hold off;

%Function to find buildings in the image
function r=findBuildings(B,h,stats)
r = {};
l=0;
for k = 1:length(B)
    metric = stats(k).MajorAxisLength/stats(k).MinorAxisLength;
    testRoof(k);
end
    function testRoof(k)
        if  metric < 2.0 && metric > 1.8 && stats(k).Area > 30000
            l=l+1;
            r(l,:)=cell(size(B(k)));
        elseif metric < 2.0 && metric > 1.3 && stats(k).Area > 1000
            l=l+1;
          
                r(l,:)=B(k);
        else
            delete(h(k))
        end
    end
end
