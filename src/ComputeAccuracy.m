%%%%%%%%%%%%%%%%%%%
%%%
%%% Computes Overall Accuracy, Average Class Accuracy and Jaccard Index
%%%
%%%%%%%%%%%%%%%%%%%

function [overall, perClass, iou] = ComputeAccuracy(gtPath, basePath, imgList, ext, numClasses, filePath)

f = fopen(imgList,'r');
imgList = textscan(f,'%s');
imgList = imgList{1};
overallList = imgList;
iouList = imgList;

overall = zeros(length(imgList),length(ext));
perClass = zeros(length(imgList),numClasses,length(ext));
perClassIOU = zeros(length(imgList),numClasses,length(ext));
iou = zeros(length(imgList),length(ext));

for k = 1 : length(ext)
	for i = 1 : length(imgList)
		gt = load([gtPath imgList{i,1} '.txt']); 
    lbl = load([basePath imgList{i,1} ext{k}]);   
		hasLabels = zeros(1,numClasses);
    overall(i,k) = nnz(gt==lbl) / nnz(gt>=0);
    for j = 0 : numClasses-1
        if nnz(gt==j)>0
            perClass(i,j+1,k) = nnz(lbl==j & gt==j) / nnz(gt==j);
						perClassIOU(i,j+1,k) = nnz(lbl==j & gt==j) / nnz(lbl==j | gt==j);
						hasLabels(j+1) = 1;
        else
            perClass(i,j+1,k) = 1;
        end
    end
		[indx] = find(hasLabels==1);
		iou(i,k) = mean(perClassIOU(i,indx,k));
%    iou(i,k) = nnz(lbl==gt) / (nnz(gt>=0) + nnz(lbl~=gt & gt>=0));
%    iou(i,k) = nnz(lbl==gt) / (nnz(gt==lbl) + nnz(lbl~=gt & gt>=0));
		overallList{i,k+1} = overall(i,k);
		iouList{i,k+1} = iou(i,k);
	end
	k
end

cell2CSV([filePath '_overall.csv'],overallList);
cell2CSV([filePath '_iou.csv'],iouList);
overall = mean(overall);
perClass = reshape(mean(perClass),[numClasses length(ext)]);
iou = mean(iou);

end
