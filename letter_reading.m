clc;clear;close all;
for index = 1:3
        jpgFileName = sprintf('envelope%d.jpg',index);
       
    iCurrent(index) = imread('envelope%d.jpg');

%iCurrent = imrotate(iCurrent,-100,'crop');
iMed = medfilt2(iCurrent,[100 100]);
iFinal = iMed - iCurrent;
BW = iFinal > 50;

[H,T,R] = hough(BW);
P  = houghpeaks(H,5,'threshold',ceil(0.3*max(H(:))));

lines = houghlines(BW,T,R,P,'FillGap',5,'MinLength',7);
% figure, imshow(iCurrent), hold on
max_len = 0;
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
%    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

   % Plot beginnings and ends of lines
%    plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
%    plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

   % Determine the endpoints of the longest line segment
   len = norm(lines(k).point1 - lines(k).point2);
   if ( len > max_len)
      max_len = len;
      xy_long = xy;
   end
end

if(lines(1).theta ~= 90)
    offSetTheta =  (lines(1).theta - 90) ;
    if(abs(offSetTheta) < 90 )
     offSetTheta = offSetTheta - 180;

    
    end
end
iRot = imrotate(BW,offSetTheta,'crop');
figure
imshow(iRot);
[H,T,R] = hough(iRot);
P  = houghpeaks(H,5,'threshold',ceil(0.3*max(H(:))));

lines = houghlines(BW,T,R,P,'FillGap',5,'MinLength',7);

for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
%    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

   % Plot beginnings and ends of lines
%    plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
%    plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

   % Determine the endpoints of the longest line segment
   len = norm(lines(k).point1 - lines(k).point2);
   if ( len > max_len)
      max_len = len;
      xy_long = xy;
   end
end

if(lines(1).point2(2) < 400)
    iRot = imrotate(iRot,180,'crop');
end
figure
imshow(iRot);