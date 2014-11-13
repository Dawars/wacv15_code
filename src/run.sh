#!/bin/bash
numFolds=5
numStages=3
#dataset="ecp"
#configFileName="ecpConfigFile.xml"
dataset="graz"
configFileName="grazConfigFile.xml"
#dataset="etrims"
#configFileName="etrimsConfigFile.xml"
#dataset="cmp12"
#configFileName="cmp12ConfigFile.xml"
#dataset="labelme"
#configFileName="labelmeConfigFile.xml"

tmpPath="tmp/";
darwin="./../lib/drwn/bin"
matlab="/usr/local/MATLAB/R2013a/bin/matlab"

rm -rf $tmpPath temp.sh allImages.txt
mkdir $tmpPath 

for (( c=1; c<=$numFolds; c++ ))
do
	${darwin}/convertPixelLabels -config $configFileName -i .png -o .txt ../data/${dataset}/data/set${c}.txt
done

for (( c=1; c<=$numFolds; c++ ))
do
	for (( s=1; s<=$numStages; s++ ))
	do
		echo "Fold :: $c Stage :: $s"
		${matlab} -nodisplay -r "facadeSeg('${configFileName}',str2num('${numFolds}'),str2num('${numStages}'),'${tmpPath}',str2num('${c}'),str2num('${s}'));quit;"
		chmod +x temp.sh
		./temp.sh || exit -1
		iou_imgList="${tmpPath}fold${c}test${numFolds}.txt"
		tmpconfigFileName="${tmpPath}config_fold${c}_stage${s}.xml"
		${darwin}/scorePixelLabels -confusion -config ${tmpconfigFileName} -inLabels .fold${c}stage${s}.unary.txt -outScores ${dataset}_fold${c}stage${s}.txt ${iou_imgList}
 		echo "Dataset : ${dataset} Fold : ${c} Stage : ${s} Finsihed!" 
	done
done
for (( c=1; c<=$numFolds; c++ ))
do
	for (( s=1; s<=$numStages; s++ ))
	do
		echo "================Fold :: $c Stage :: $s===================="
		iou_imgList="${tmpPath}fold${c}test${numFolds}.txt"
		${darwin}/scorePixelLabels -confusion -config ${tmpPath}config_fold${c}_stage${s}.xml -inLabels .fold${c}stage${s}.unary.txt ${iou_imgList}
	done
done
rm -rf $tmpPath temp.sh allImages.txt
