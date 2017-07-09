close all;

BW = imbinarize(rgb2gray(imread('imageRGB.png')));
imshow(BW,[]);
s=size(BW);
contour = bwtraceboundary(BW);
if(~isempty(contour))
    hold on; plot(contour(:,2),contour(:,1),'g','LineWidth',2);
    hold on; plot(col, row,'gx','LineWidth',2);
    
    hold off;
end
    %     end
    % for row = 2:55:s(1)
    %     for col=1:s(2)
    %         if BW(row,col)
    %             break;
    %         end
    %     end
    %
    %     contour = bwtraceboundary(BW, [row, col],'w');
    %     if(~isempty(contour))
    %         hold on; plot(contour(:,2),contour(:,1),'g','LineWidth',2);
    %         hold on; plot(col, row,'gx','LineWidth',2);
    %     end
    % end