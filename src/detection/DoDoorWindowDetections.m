function DoDoorWindowDetections(trainListFile,testListFile,outDir,doorLabel,windowLabel,imageDir,gtLabelDir,numClasses)

%Create a folder to save data related to present fold
[a,trainListName,c] = fileparts(trainListFile);
[a,testListName,c] = fileparts(testListFile);
foldDir = strcat(outDir,'/',trainListName,'_',testListName);
if~isdir(foldDir)
    mkdir(foldDir);
end

%Read image names into cell array
f = fopen(trainListFile,'r');
trainDataFiles = textscan(f,'%s');
trainDataFiles = trainDataFiles{1};

f = fopen(testListFile,'r');
testDataFiles = textscan(f,'%s');
testDataFiles = testDataFiles{1};

%Create GT annotations and also compute size statistics of doors and
%windows
annotationDir = strcat(foldDir,'/annotations/');
statsFile = strcat(outDir,'/stats.mat');
if ~isdir(annotationDir)
    mkdir(annotationDir);
    CreateGTAnnotations(trainDataFiles,gtLabelDir,annotationDir,outDir,doorLabel,windowLabel,numClasses);
elseif ~exist(statsFile,'file')
    CreateGTAnnotations(trainDataFiles,gtLabelDir,annotationDir,outDir,doorLabel,windowLabel,numClasses);
end


%Train the detectors and extract features
modelDir = strcat(foldDir,'/detection_models/');
if ~isdir(modelDir)
    mkdir(modelDir);
end
DoDetections(trainDataFiles,testDataFiles,imageDir,annotationDir,outDir,modelDir,outDir,doorLabel,windowLabel,numClasses);

end
