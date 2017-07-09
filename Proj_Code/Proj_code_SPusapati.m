close all;
clc;
%{
 Execute this file to get the outputs like corner points, surface points, 
 building roofs on boundary analysis image and building roofs after
 statistical analysis
%}

%Extract features that best describe building roofs in the following image
% Read the image
ori = imread('imageRGB.png');
disp('Best features that describe building roofs are the corner points and surface features');
%Converting to grayscale image.
street1 = rgb2gray(ori);

%Finding the corner points using fast features
pts = detectFASTFeatures(street1);
[features, validCorners] = extractFeatures(street1,pts);
%finding the surface points
x=detectSURFFeatures(street1);


figure,
imshow(street1);
title('Corner points strongest 100');
hold on;
plot(validCorners.selectStrongest(100));
hold off;

figure,
imshow(street1);
title('Surface features strongest 50');
hold on;
plot(x.selectStrongest(50));
hold off;


% Scale image
scaled=street1*1.2;

% Thresholding image
level=120;
bin = scaled>level;
% figure,
% imshow(bin);
% title('Threshold image');

% Remove the noise
bin = bwareaopen(bin,1000);
figure,
imshow(bin),
title('Noise reduced image');

% Find the boundaries of objects
[B,L] = bwboundaries(bin);

h = zeros(1, length(B));
figure,
imshow(bin),
title('Roof tops after boundary analysis');
hold on;
% Plot boundaries
for K=1:length(B)
    boundary = B{K};
    h(K)=plot(boundary(:,2), boundary(:,1), 'g', 'LineWidth', 1);
end

% Extract statistics
stats = regionprops(L,'MajorAxisLength','MinorAxisLength','Area');

% Find roofs and delete non-building objects
roofs = findBuildings(B,h,stats);
hold off;

% Place roofs on original image
figure,
imshow(bin);
title('Roof tops after analysis');
hold on;
for K = 1:length(roofs)
    if(size(roofs{K})>1)
        plot(roofs{K}(:,2), roofs{K}(:,1), 'g', 'LineWidth', 1);
    end
end
hold off;

figure,
imshow(ori);
title('Roof tops');
hold on;
for K = 1:length(roofs)
    if(size(roofs{K})>1)
        plot(roofs{K}(:,2), roofs{K}(:,  1), 'r', 'LineWidth', 1);
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
        if metric < 2.0 && metric >1.5 && stats(k).Area > 20000
            B(k)={0};
        end
        if  metric < 2.0 && metric > 1.3 && stats(k).Area > 1000
            l=l+1;
            r(l,:)=B(k);
        else
            delete(h(k))
        end
    end
end
