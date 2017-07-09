%{
Execute the following, it has inputs as circle and rectangle,
-> finds the chain code of the given image followed by normalized values
and differential values.
-> finds a fourier tranformation of the found boundary points and
reconstraction 
-> Tests the functions for circle and rectangle.
-> Bonus shape distribution 
%}
%Find the outputs in "outputs.txt"
clear;
close all;
clc;

image=imread('circle.jpg');%Taking in the circle image
image1=imread('rectangle.jpg');% Taking in the rectangle image
image=convertToBinary(image);
image1=convertToBinary(image1);

fileID = fopen('outputs.txt','w');

figure,
imshow(image);
title('Original circle');

figure,
imshow(image1);
title('original rectangle');

[out,chaincode]=chainCode(image);
[out1,chaincode1]=chainCode(image1);
fprintf(fileID,'Chain code vlaues for circle: ');
fprintf(fileID,'%d',chaincode');
fprintf(fileID,'\n');

fprintf(fileID,'Chain code vlaues for rectangle: ');
fprintf(fileID,'%d',chaincode1');
fprintf(fileID,'\n');

% Another way for chain code 
% chainout=chaincodeAnotherTry(image);
% disp('Chain code for cirlce');
% disp(chainout);
% chainout1=chaincodeAnotherTry(image1);
% disp('Chain code for rectangle');
% disp(chainout1);

normalizedresult=normalizedValues(chaincode');
normalizedresult1=normalizedValues(chaincode1');
fprintf(fileID,'Normalized values for circle: ');
fprintf(fileID,'%d',normalizedresult);
fprintf(fileID,'\n');

fprintf(fileID,'Normalized values for rectangle: ');
fprintf(fileID,'%d',normalizedresult1);
fprintf(fileID,'\n');


diffResult=differentialChainCode(chaincode');
fprintf(fileID,'Differential values for circle: ');
fprintf(fileID,'%d',diffResult);
fprintf(fileID,'\n');

diffResult1=differentialChainCode(chaincode1');
fprintf(fileID,'Differential values for rectangle: ');
fprintf(fileID,'%d',diffResult1);
fprintf(fileID,'\n');

%The sequence of the boundary points are considered as complex numbers
%s=x+iy
fourierDisc=fourierDiscriptor(out);
fourierDisc1=fourierDiscriptor(out1);



%Shape distribution
resolution = 30;
mDist = 10;
% GetD2(P,n,d,d2,r) P- Points set, n- no. of points d- max distance,
% r-resolution, d2- array
sam = [1, 2, 10, 20, 50, 30,20, 60,20,10, 4, 20, 5];
res = shDist(resolution, mDist, sam);
fprintf(fileID,'The result array: ');
fprintf(fileID,' %d ',res);
figure,
title('Shape distribution');
histfit(res,20);



function [out] = shDist(resolution, maxD, sample)
%Function for shape distribution.
out = zeros(1,length(sample));
c = 0;
for i = 1:length(sample)
    for j = 1: i
        t = abs(sample(i) - sample(j));
        if (t < maxD)
            ind = floor((t / maxD) * resolution);
            if(ind == 0)
                ind = 1;
            end
            if(ind > length(sample))
                ind = length(sample);
            end
            out(ind) = out(ind) + 1;
            c = c + 1;
        end
    end
end
out = out / c;
end

function fourierVal=fourierDiscriptor(contour)
%Function to find the fourier discriptor of the given boundary values
figure,
plot(contour(:,1),contour(:,2),'g');
title('On plotting boundary points before fourier transform');

%Creating the complex values
cmplxValues=complex(contour(:,1),contour(:,2));

%Applying the fourier transformations
fourierVal=fft(cmplxValues);

f1=zeros(size(fourierVal));
%Approximation for P terms
approx=4;
f1(1:approx)=fourierVal(1:approx);
%Inverse fourier transformation 
ifftf1=ifft(f1);

%Displaying the reconstruncted image
figure,
plot(ifftf1,'d'),
title(['Fourier descriptor after approximating to ',num2str(approx)]);
end

function diffValues=differentialChainCode(chaincode)
%Function to find the differential chain code
i=numel(chaincode);% length of the chaincode
chainCode1=[chaincode(2:i),chaincode(1)]; %creating a temp 
diffValues=mod((chainCode1-chaincode),4); %dk= (ck-c(k-1)) mod 4 for 4-directional chain codes

end

function out=normalizedValues(chaincode)
%function to find normalized values
P=gallery('circul',chaincode);
%Sorting all the rows
sortedRows=sortrows(P);
%First row of the sorted row is the normalized values
out=sortedRows(1,:);
end



function out=convertToBinary(image)
%Function to convert to Binary image

if(size(image,3)>1)%if the image is not a grayscale image
    image=rgb2gray(image);
end
if(size(image,3)==1)
    out=imbinarize(image);%converting the image to binary values
end
end

function [out,chaincode]=chainCode(image)
%Function to find the chain code for the given image.

%Finding the starting point for the image on the top left.
[start_r,start_c] = find(image,1,'first');
%Tracing the boundary for the image. output of the function are the points
%which can be used to send for converting into the chain code values.
contour = bwtraceboundary(image, [start_r,start_c],'E' , 4);
chaincode=mod(3*contour(:,1)+contour(:,2)+5,4);
out=contour;

end
%Another attempt for the chain code
% function out=chaincodeAnotherTry(image)
% %Function to find the chain code for the given image.
% %The four directions is represented as such
% directions=[0 1;-1 0;0 -1;1 0];
% % position of first non-zero pixel in the top left
% [start_x,start_y] = find(image,1,'first');
% first=[start_x,start_y];
% dir=3;
% flag =1;
% cc=[];
% while flag==1
%     temp=zeros(1,4);
%     dir=mod(dir+3,4);
%     %checking all the directions
%     for i=0:3
%         j=mod(dir+i,4)+1;
%         temp(i+1)=image(start_x+directions(j,1),start_y+directions(j,2));
%     end
%     %checking the imediate pixel with 1
%     nPixel=find(temp,1,'first');
%     dir=mod(dir+nPixel-1,4);
%     cc=[cc;dir];
%     % Updating to next point
%     start_x=start_x+directions(dir+1,1);start_y=start_y+directions(dir+1,2);
%
%     %exit the loop
%     if start_x==first(1) && start_y==first(2)
%         flag=0;
%     end
% end
% %Function output transpose of the result
% out=cc';
% end


