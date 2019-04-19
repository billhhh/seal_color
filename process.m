%清空变量，读取图像，并显示其属性
clear;close all
src = imread('ori2.jpg');
whos,

%显示原始图像
figure('name','myapp'),
subplot(2,2,1),imshow(src),title('src')

%用ostu方法获取二值化阈值，进行二值化并进行显示
level=graythresh(src);
bw=im2bw(src,level);
subplot(2,2,2),imshow(bw),title('bw')

%运用开操作消去噪点
se = strel('disk',2);
openbw=imopen(bw,se);
subplot(2,2,3),imshow(openbw),title('open')
imwrite(openbw, 'ori_bw.png')

% openbw_rgb = uint8(openbw(:,:,[1 1 1]) * 255)
[fil, col] = size(openbw);
openbw_rgb = uint8(openbw(:,:,[1 1 1]) * 255)
[posX , posY] = find(openbw == 0);
numIter = size(posX,1)*size(posX,2);
for i = 1 : numIter
      openbw_rgb(posX(i),posY(i), 1) = 255;
      openbw_rgb(posX(i),posY(i), 2:3) = 0;
end % for
imshow(openbw_rgb),title('openbw rgb')
imwrite(openbw_rgb, 'whole_red.png')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%获取连通区域，并进行显示
L = bwlabel(openbw,4);
RGB = label2rgb(L);
subplot(2,2,4),imshow(RGB),title('rgb')

%获取区域的'basic'属性， 'Area', 'Centroid', and 'BoundingBox' 
stats = regionprops(openbw, 'basic');
centroids = cat(1, stats.Centroid);
figure('name','regionprops'),
%绘制开操作之后的二值化图像
imshow(openbw),title('centroids')  
hold on
%绘制重心
plot(centroids(:,1), centroids(:,2), 'b*'),
%绘制感兴趣区域ROI
for i=1:size(stats)
     rectangle('Position',[stats(i).BoundingBox],'LineWidth',2,'LineStyle','--','EdgeColor','r'),
end
hold off
