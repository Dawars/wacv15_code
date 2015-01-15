function runDetection(numFolds, tmppath, fold, outputDir, doorLabel, windowLabel, imgDir, lblDir, numRegions, dataset)

addpath(genpath('../lib/toolbox'));
addpath('detection');

%% Facade Segmentation
arr = [1 : numFolds]; perm_arr = perms(arr); perm_arr = perm_arr(factorial(numFolds-1)*arr',:);

trainList = [tmppath 'fold' num2str(fold) 'train'];
testList  = [tmppath 'fold' num2str(fold) 'test' ];
% detections

    for i=1:numFolds-1
        trainFileName = [trainList num2str(i) '.txt'];
        trainIndx = setdiff(arr,[arr(1) arr(1+i)]);
        for j=1:length(trainIndx)
            f3 = ['../data/' dataset '/set' num2str(trainIndx(j)) '.txt' ];
            shLine = ['cat ' f3 ' >> ' trainFileName]; system(shLine);
        end
        testFileName = [testList num2str(i) '.txt'];
        testIndx = arr(1+i);
        f3 = ['../data/' dataset '/set' num2str(testIndx) '.txt' ];
        shLine = ['cat ' f3 ' >> ' testFileName]; system(shLine);
		outputDir = [outputDir 'fold' num2str(fold) '/'];
		DoDoorWindowDetections(trainFileName,testFileName,outputDir,doorLabel,windowLabel,imgDir,lblDir,numRegions);
    end

% final train
trainFileName=[trainList num2str(numFolds) '.txt'];
testFileName=[testList num2str(numFolds) '.txt'];
trainIndx = setdiff(arr,[arr(1)]); 
for j=1:length(trainIndx)
    f3 = ['../data/' dataset '/set' num2str(trainIndx(j)) '.txt'];
    shLine = ['cat ' f3 ' >> ' trainFileName]; system(shLine);
end
% final test
testIndx = arr(1);
f3 = ['../data/' dataset '/set' num2str(testIndx) '.txt'];
shLine = ['cat ' f3 ' >> ' testFileName]; system(shLine);
DoDoorWindowDetections(trainFileName,testFileName,outputDir,doorLabel,windowLabel,imgDir,lblDir,numRegions);
