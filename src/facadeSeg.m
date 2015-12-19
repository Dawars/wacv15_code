function facadeSeg(configFileName, numFolds, numStages, tmppath, fold, stage)

%shFile = [tmppath 'temp.sh'];
shFile = 'temp.sh';
fsh = fopen(shFile,'w');
fprintf(fsh,'#!/bin/bash\n');

%% drwn commands
cmd = cell(3,1);
cmd{1} = './../lib/drwn/bin/learnPixelSegModel -component BOOSTED -set drwnDecisionTree split MISCLASS -set drwnBoostedClassifier numRounds 200 -subSample 250 ';
cmd{2} = './../lib/drwn/bin/learnPixelSegModel -component UNARY -subSample 25 ';
cmd{3} = './../lib/drwn/bin/inferPixelLabels -pairwise 0.0 ';
%pairwise
cmd{4} = './../lib/drwn/bin/learnPixelSegModel -component CONTRAST ';
cmd{5} = './../lib/drwn/bin/inferPixelLabels ';

%% parse the config file
try
    xDoc = xmlread(configFileName);
    drwn = xDoc.getDocumentElement;
    options = drwn.getElementsByTagName('option');
    for i = 0:options.getLength-1
        name = options.item(i).getAttribute('name');
        if (strcmpi(name, 'baseDir')) baseDir = char(options.item(i).getAttribute('value')); end
        if (strcmpi(name, 'imgDir')) imgDir = [baseDir  '/' char(options.item(i).getAttribute('value'))]; end
        if (strcmpi(name, 'lblDir')) lblDir = [baseDir '/' char(options.item(i).getAttribute('value'))]; end
        if (strcmpi(name, 'outputDir')) outputDir = [baseDir '/' char(options.item(i).getAttribute('value'))]; end
        if (strcmpi(name, 'auxFeatureDir')) auxFeatureDir = [char(options.item(i).getAttribute('value'))]; end
    end
    %regions = drwn.getElementsByTagName('region');
catch
    fprintf(2, 'config file errror!\n');
    return;
end

allImages = [tmppath 'allImages.txt'];
allImages = 'allImages.txt';
if (exist(allImages, 'file') ~= 2)
    for i = 1 : numFolds
        f3 = [imgDir '../../set' num2str(i) '.txt' ];
        shLine = ['cat ' f3 ' >> ' allImages]; system(shLine);
    end
end

%% Facade Segmentation
addpath(genpath('../lib/toolbox/'));addpath( 'detection');
addpath('autocontext');


arr = [1 : numFolds]; perm_arr = perms(arr); perm_arr = perm_arr(factorial(numFolds-1)*arr',:);
%[stat, mess, id]=rmdir(tmppath,'s'); mkdir(tmppath);

tmpXmlName = [tmppath 'config_fold' num2str(fold) '_stage' num2str(stage) '.xml'];
arr = perm_arr(fold,:);
saveimages = [' -outImages .fold' num2str(fold) 'stage' num2str(stage) '.unary.png '];
savelabels = [' -outLabels .fold' num2str(fold) 'stage' num2str(stage) '.unary.txt '];
saveunary  = [' -outUnary .fold'  num2str(fold) '.pot.txt '];
savepair = [' -outLabels .fold' num2str(fold) 'stage' num2str(stage) '.pairwise.txt -outImages .fold' num2str(fold) 'stage' num2str(stage) '.pairwise.png '];
config = [' -config ' tmpXmlName ' '];
trainList = [tmppath 'fold' num2str(fold) 'train'];
testList  = [tmppath 'fold' num2str(fold) 'test' ];

xDoc = xmlread(configFileName); drwn = xDoc.getDocumentElement; options = drwn.getElementsByTagName('option');

regionDefinitions = drwn.getElementsByTagName('regionDefinitions');
regions = regionDefinitions.item(0).getChildNodes;
node = regions.getFirstChild; numRegions =0 ;
while ~isempty(node)
    if strcmpi(node.getNodeName, 'region')
        numRegions = numRegions + 1;
        name = node.getAttribute('name');
        if (strcmpi(name, 'window'))
            windowLabel = str2num(char(node.getAttribute('id')));
        end
        if (strcmpi(name, 'door'))
            doorLabel = str2num(char(node.getAttribute('id')));
        end
    end
    node = node.getNextSibling;
end

for i = 0:options.getLength-1
    name = options.item(i).getAttribute('name');
    if (strcmpi(name, 'outputDir'))
        outputDir = [char(options.item(i).getAttribute('value'))];
        outputDir = [outputDir 'fold' num2str(fold) '/'];
        options.item(i).setAttribute('value',outputDir);
        if~isdir([baseDir '/' outputDir]) mkdir([baseDir '/' outputDir]); end
    end
    if (strcmpi(name, 'cacheDir'))
        cacheDir = [char(options.item(i).getAttribute('value'))];
        cacheDir = [cacheDir 'fold' num2str(fold) '/'];
        options.item(i).setAttribute('value',cacheDir);
        if~isdir([baseDir '/' cacheDir]) mkdir([baseDir '/' cacheDir]); end
    end
    if (strcmpi(name, 'modelsDir'))
        modelsDir = [char(options.item(i).getAttribute('value'))];
        %modelsDir = [modelsDir 'fold' num2str(fold) '/stage' num2str(stage) '/'];
        modelsDir = [modelsDir 'fold' num2str(fold) '/'];
        options.item(i).setAttribute('value',modelsDir);
        if~isdir([baseDir '/' modelsDir]) mkdir([baseDir '/' modelsDir]); end
    end

    if (strcmpi(name, 'auxFeatureDir'))% && stage~=1)
        %outputDir = [baseDir '/' char(options.item(i).getAttribute('value'))];
        auxFeatureDir = char(options.item(i).getAttribute('value'));
        auxFeatureDir = [baseDir '/' outputDir]; %[auxFeatureDir 'fold' num2str(fold) '/'];
        options.item(i).setAttribute('value',auxFeatureDir);
        if~isdir(auxFeatureDir) mkdir(auxFeatureDir); end
    end
    if (strcmpi(name, 'auxFeatureExt') && stage~=1)
        fileExt = ['.fold' num2str(fold) '.pot.txt'];
        inputDir = [baseDir '/' outputDir];
        outputDir = [baseDir '/' outputDir];				
        featstr = extractFeatures_binary(allImages, inputDir, outputDir, imgDir, numRegions, fileExt);
        auxFeatureExt = char(options.item(i).getAttribute('value'));
        auxFeatureExt = [auxFeatureExt ' ' featstr];
        options.item(i).setAttribute('value',auxFeatureExt);
    end
end
xmlwrite(tmpXmlName, drwn); % xDoc
% detections
if (stage==1)
    for i=1:numFolds-1
        trainFileName = [trainList num2str(i) '.txt'];
        trainIndx = setdiff(arr,[arr(1) arr(1+i)]);
        for j=1:length(trainIndx)
            f3 = [imgDir '../../set' num2str(trainIndx(j)) '.txt' ];
            shLine = ['cat ' f3 ' >> ' trainFileName]; system(shLine);
        end
        testFileName = [testList num2str(i) '.txt'];
        testIndx = arr(1+i);
        f3 = [imgDir '../../set' num2str(testIndx) '.txt' ];
        shLine = ['cat ' f3 ' >> ' testFileName]; system(shLine);
        %detections disabled!!!
        %DoDoorWindowDetections(trainFileName,testFileName,outputDir,doorLabel,windowLabel,imgDir,lblDir,numRegions);
        %fprintf(fsh,'%s\n',['/usr/local/MATLAB/R2013a/bin/matlab -nodisplay -r "addpath(genpath(''../lib/toolbox/''));addpath( ''detection'');DoDoorWindowDetections(''' trainFileName ''',''' testFileName ''',''' outputDir ''',' num2str(doorLabel) ',' num2str(windowLabel) ',''' imgDir ''',''' lblDir ''',' num2str(numRegions) ');quit;"' ' & ']);
    end
end

% final train
trainFileName=[trainList num2str(numFolds) '.txt'];
testFileName=[testList num2str(numFolds) '.txt'];
if (stage==1)
    trainIndx = setdiff(arr,[arr(1)]);
    for j=1:length(trainIndx)
        f3 = [imgDir '../../set' num2str(trainIndx(j)) '.txt'];
        shLine = ['cat ' f3 ' >> ' trainFileName]; system(shLine);
    end
    % final test
    testIndx = arr(1);
    f3 = [imgDir '../../set' num2str(testIndx) '.txt'];
    shLine = ['cat ' f3 ' >> ' testFileName]; system(shLine);
    %detections disabled!!!!
    %DoDoorWindowDetections(trainFileName,testFileName,outputDir,doorLabel,windowLabel,imgDir,lblDir,numRegions);
    %fprintf(fsh,'%s\n',['/usr/local/MATLAB/R2013a/bin/matlab -nodisplay -r "addpath(genpath(''../lib/toolbox/''));addpath( ''detection'');DoDoorWindowDetections(''' trainFileName ''',''' testFileName ''',''' outputDir ''',' num2str(doorLabel) ',' num2str(windowLabel) ',''' imgDir ''',''' lblDir ''',' num2str(numRegions) ');quit;"' ' & ']);
end
%fprintf(fsh,'wait\n');
% execute
if (stage<numStages)
    for i=1:numFolds-1
        trainFileName = [trainList num2str(i) '.txt'];
        testFileName = [testList num2str(i) '.txt'];
        shLine = [cmd{1} config trainFileName];fprintf(fsh,'%s\n',shLine);
        shLine = [cmd{2} config trainFileName];fprintf(fsh,'%s\n',shLine);
        shLine = [cmd{3} config saveimages savelabels saveunary testFileName];fprintf(fsh,'%s\n',shLine);
    end
end
trainFileName=[trainList num2str(numFolds) '.txt'];
testFileName=[testList num2str(numFolds) '.txt'];
shLine = [cmd{1} config trainFileName];fprintf(fsh,'%s\n',shLine);
shLine = [cmd{2} config trainFileName];fprintf(fsh,'%s\n',shLine);
shLine = [cmd{3} config saveimages savelabels saveunary testFileName];fprintf(fsh,'%s\n',shLine);
%shLine = [cmd{4} config trainList num2str(randi(numFolds-1,1)) '.txt'];fprintf(fsh,'%s\n',shLine);
%shLine = [cmd{5} config savepair testFileName];fprintf(fsh,'%s\n',shLine);
fclose(fsh);
