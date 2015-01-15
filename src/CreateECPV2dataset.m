
clear all; close all; clc;

imgPath = '../data/ecp/data/images/';
destPath = '../data/ecpV3/data/images/';

imgList = dir([imgPath '*.png']);

for i = 1 : length(imgList)
    img = double(imread([imgPath imgList(i).name]));
    [~,imgName,~] = fileparts(imgList(i).name);
    f = imgName;
    n = rand();
    if (n<0.5)
        treeDir = '../data/trees/large/';
        s = 1.1;
%     elseif (n>=0.35  && n<0.60)
    elseif (n>=0.5)
         treeDir = '../data/trees/medium/';
         s = 1.4;
%     elseif (n>=0.60 && n<0.85)
%         treeDir = '../data/trees/small/';
%         s = 1.5;
%     elseif (n>=0.85)
%         treeDir = '../data/trees/very_small/';
%         s = 2.0;
    end
%     try
        f = [f ' ' treeDir];
        treeList = dir([treeDir '*.png']);
        treenum = randi(length(treeList),1);
        [~,timgName,~] = fileparts(treeList(treenum).name);
        [timg,~,talpha] = imread([treeDir treeList(treenum).name]);
        treeSize = size(timg); imgSize = size(img);
        scaleFactor = randi( round([imgSize(1)/2 imgSize(1)/s]), 1) / treeSize(1);
        timg = double(imresize(timg, scaleFactor));
        timg = timg(1:end-15,:,:);
        treeSize = size(timg);
        talpha = double(imresize(talpha,scaleFactor));
        
        treePos = randi(round([-treeSize(2)/2  imgSize(2)-treeSize(2)/2]),1);
        
        for x = imgSize(1)-treeSize(1)+1:imgSize(1)
            for y = treePos+1:treePos+treeSize(2)
                if (x>=1 && x<=imgSize(1) && y>=1 && y<=imgSize(2))
                    img(x,y,:) = ((255-talpha(x-imgSize(1)+treeSize(1),y-treePos))*img(x,y,:) + (talpha(x-imgSize(1)+treeSize(1),y-treePos))*timg(x-imgSize(1)+treeSize(1),y-treePos,:))/255;
                end
            end
        end
%     catch
%         i = i -1;
%         fprintf(1,'%s\n',[f ' reselecting']);
%     end
    fprintf(2,'%s\n',f);
    imwrite(uint8(img),[destPath imgName '.png'],'png');    
end
%imshow(uint8(img)); pause(2); close all;

% scaleFactor = randi( round([imgSize(1)/4 imgSize(1)/1.25]), 1) / treeSize(1);
% if (n==1)
%     treenum = randi(length(largetreeList),1);
%     [~,timgName,~] = fileparts(largetreeList(treenum).name);
%     [timg,~,talpha] = imread([largetreePath largetreeList(treenum).name]);
%     treeSize = size(timg); imgSize = size(img);
%     scaleFactor = randi( round([imgSize(1)/4 imgSize(1)/1.25]), 1) / treeSize(1);
% elseif (n==2)
%     treenum = randi(length(mediumtreeList),1);
%     [~,timgName,~] = fileparts(mediumtreeList(treenum).name);
%     [timg,~,talpha] = imread([mediumtreePath mediumtreeList(treenum).name]);
%     treeSize = size(timg); imgSize = size(img);
%     scaleFactor = randi( round([imgSize(1)/4 imgSize(1)/2]), 1) / treeSize(1);
% elseif (n==3)
%     treenum = randi(length(smalltreeList),1);
%     [~,timgName,~] = fileparts(smalltreeList(treenum).name);
%     [timg,~,talpha] = imread([smalltreePath treeList(treenum).name]);
%     treeSize = size(timg); imgSize = size(img);
%     scaleFactor = randi( round([imgSize(1)/4 imgSize(1)/2.25]), 1) / treeSize(1);
% elseif (n==4)
%     treenum = randi(length(verysmalltreeList),1);
%     [~,timgName,~] = fileparts(verysmalltreeList(treenum).name);
%     [timg,~,talpha] = imread([verysmalltreePath treeList(treenum).name]);
%     treeSize = size(timg); imgSize = size(img);
%     scaleFactor = randi( round([imgSize(1)/4 imgSize(1)/3]), 1) / treeSize(1);
% end
% largetreePath = 'large/';
% mediumtreePath = 'medium/';
% smalltreePath = 'small/';
% verysmalltreePath = 'very_small/';
% largetreeList = dir([largetreePath '*.png']);
% mediumtreeList = dir([mediumtreePath '*.png']);
% smalltreeList = dir([smalltreePath '*.png']);
% verysmalltreeList = dir([verysmalltreePath '*.png']);
