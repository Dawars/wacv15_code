function iou_optimize(configFileName, imgList, fold, stage)

try
    xDoc = xmlread(configFileName);
    drwn = xDoc.getDocumentElement;
    options = drwn.getElementsByTagName('option');
    for i = 0:options.getLength-1
        name = options.item(i).getAttribute('name');
        if (strcmpi(name, 'baseDir')) baseDir = char(options.item(i).getAttribute('value')); end
        if (strcmpi(name, 'outputDir')) outputDir = char(options.item(i).getAttribute('value')); end
    end
catch
    fprintf(2, 'config file errror!\n');
    return;
end

file = fopen(imgList);
unaryFiles = textscan(file,'%s');
unaryFiles = unaryFiles{1};

try
    matlabpool close;
end
try
	if (feature('numCores') >= 4)
    matlabpool open 8;
	else
		matlabpool open 4;
	end
end

addpath(genpath('../lib/cvpr2014-iou-code-1.0/matlab/'));
options=[];
options.algorithm='greedy';

for i = 1:1:length(unaryFiles)
    img_name = unaryFiles{i};
    unaries = load([baseDir outputDir img_name '.fold' num2str(fold) '.pot.txt']);
		[c d] = size(unaries);
    unaries = exp(-1*unaries); unaries = unaries';
		[Y, rec, obj] = voc_optimize(unaries, options);Y = Y-1;
    orig_lbl = load([baseDir outputDir img_name '.fold' num2str(fold) 'stage' num2str(stage) '.unary.txt']);
		[a,b] = size(orig_lbl);
		outName = [baseDir outputDir img_name '.fold' num2str(fold) 'stage' num2str(stage) '.iouunary.txt'];
		dlmwrite(outName,reshape(Y,[b a])',' '); 
end

matlabpool close;
