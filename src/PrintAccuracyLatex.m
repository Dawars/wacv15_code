
dataset = 'ecp';numClasses = 7; numStages = 3;
dataset = 'graz';numClasses = 4; numStages = 3;
ext = {'.stage1.unary.txt','.stage2.unary.txt','.stage3.unary.txt','.stage1.pairwise.txt','.stage2.pairwise.txt','.stage3.pairwise.txt'};%,'.stage1.iouunary.txt','.stage2.iouunary.txt','.stage3.iouunary.txt'};
dataset = 'etrims';numClasses = 8; numStages = 3;
ext = {'.foldstage1.unary.txt','.foldstage2.unary.txt','.foldstage3.unary.txt','.foldstage1.pairwise.txt','.foldstage2.pairwise.txt','.foldstage3.pairwise.txt'};%,'.foldstage1.iouunary.txt','.foldstage2.iouunary.txt','.foldstage3.iouunary.txt'};
dataset = 'labelme';numClasses = 9; numStages = 3;
ext = {'.fold1stage1.unary.txt','.fold1stage2.unary.txt','.fold1stage3.unary.txt','.fold1stage1.pairwise.txt','.fold1stage2.pairwise.txt','.fold1stage3.pairwise.txt'};%,'.fold1stage1.iouunary.txt','.fold1stage2.iouunary.txt','.fold1stage3.iouunary.txt'};
dataset = 'cmp12';numClasses = 12; numStages = 3;
ext = {'.stage1unary.txt','.stage2unary.txt','.stage3unary.txt','.stage1pairwise.txt','.stage2pairwise.txt','.stage3pairwise.txt'};%,'.fold1stage1.iouunary.txt','.fold1stage2.iouunary.txt','.fold1stage3.iouunary.txt'};
dataset = 'ecpV2'; numClasses = 7; numStages = 3;
ext = {'stage1.unary.txt','stage2.unary.txt','stage3.unary.txt','stage1.pairwise.txt','stage2.pairwise.txt','stage3.pairwise.txt'};%,'.stage1.iouunary.txt','.stage2.iouunary.txt','.stage3.iouunary.txt'};
dataset = 'etrimsUnrectified'; numClasses = 8; numStages = 3;
ext = {'stage1.unary.txt','stage2.unary.txt','stage3.unary.txt','stage1.pairwise.txt','stage2.pairwise.txt','stage3.pairwise.txt'};%,'.stage1.iouunary.txt','.stage2.iouunary.txt','.stage3.iouunary.txt'};
%dataset = 'ecpRF'; numClasses = 7; numStages = 3;
%ext = {'.rfunary.txt'};
%dataset = 'ecpRNN'; numClasses = 7; numStages = 3;
%ext = {'.unary.txt'};
%dataset = 'ecpRNN'; numClasses = 7; numStages = 3;
%ext = {'_class.txt'};

gtPath = ['../data/' dataset '/data/labels/'];
%gtPath = ['../data/ecp/data/labels/'];
basePath = ['/home/raghudeep/Desktop/WACV/final/' dataset '/'];
%basePath = ['/home/raghudeep/Desktop/WACV/matuesz/' dataset '/'];
imgList = [basePath 'allImages.txt'];
%imgList = [basePath 'set.txt'];

%filePath = [dataset '_matuesz'];
filePath = [dataset]; 
[overall, perClass, iou] = ComputeAccuracyOverDataset(gtPath, basePath, imgList, ext, numClasses, filePath);
f = 100*[perClass; mean(perClass); overall; iou];
f
dlmwrite('latex.txt',f(1:end-3,1:length(ext)),'delimiter','&','precision',3);
dlmwrite('latex.txt',f(end-2:end,1:length(ext)),'delimiter','&','precision',4,'-append');
!cat latex.txt
