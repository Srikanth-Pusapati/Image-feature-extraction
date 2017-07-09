function [image] = findCircles(iMat1,radius)
%Function to find circles on the image within a given radius.
figure
imshow(iMat1);

[centers, radii] = imfindcircles(iMat1,[6, radius],...
    'ObjectPolarity','dark');

[centerb, radib] = imfindcircles(iMat1,[6, radius],...
    'ObjectPolarity','bright');
viscircles(centers, radii,'EdgeColor','b');

viscircles(centerb, radib,'EdgeColor','r');
handle = getframe(gcf);
[image,~]=frame2im(handle);

end