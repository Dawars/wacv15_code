#!/bin/bash
numFolds=5
numStages=1
#dataset="ecp"
#configFileName="ecpConfigFile.xml"
#dataset="graz"
#configFileName="grazConfigFile.xml"
#dataset="etrims"
#configFileName="etrimsConfigFile.xml"
#configFileName="cmp12ConfigFile.xml"
#dataset="labelme"
#configFileName="labelmeConfigFile.xml"
#dataset="artdeco"
#configFileName="artdecoConfigFile.xml"
#dataset="ecpV2"
#configFileName="ecpV2ConfigFile.xml"
dataset="ecpV3"
configFileName="ecpV3ConfigFile.xml"

tmpPath="tmp/";
darwin="./../lib/drwn/bin"
matlab="/usr/local/MATLAB/R2013a/bin/matlab"

rm -rf $tmpPath temp.sh allImages.txt
mkdir $tmpPath 

#${darwin}/convertPixelLabels -config $configFileName -i .png -o .txt 

for (( c=1; c<=$numFolds; c++ ))
do
	for (( s=1; s<=$numStages; s++ ))
	do
		echo "Fold :: $c Stage :: $s"
		${matlab} -nodisplay -r "facadeSeg('${configFileName}',str2num('${numFolds}'),str2num('${numStages}'),'${tmpPath}',str2num('${c}'),str2num('${s}'));quit;"
		chmod +x temp.sh
		./temp.sh
		iou_imgList="${tmpPath}fold${c}test${numFolds}.txt"
		tmpconfigFileName="${tmpPath}config_fold${c}_stage${s}.xml"
		${matlab} -nodisplay -r "iou_optimize('${tmpconfigFileName}','${iou_imgList}',str2num('${c}'),str2num('${s}'));quit;"
		${darwin}/scorePixelLabels -confusion -config ${tmpconfigFileName} -inLabels .fold${c}stage${s}.unary.txt -outScores ${dataset}_fold${c}stage${s}.txt ${iou_imgList}
		${darwin}/scorePixelLabels -confusion -config ${tmpconfigFileName} -inLabels .fold${c}stage${s}.iouunary.txt -outScores ${dataset}_fold${c}stage${s}_iou.txt ${iou_imgList}
 		echo "Dataset : ${dataset} Fold : ${c} Stage : ${s} Finsihed!" | /usr/sbin/sendmail raghudeep.g@gmail.com		
 		echo "Dataset : ${dataset} Fold : ${c} Stage : ${s} Finsihed!" | /usr/sbin/sendmail varunjampani@gmail.com
	done
done
for (( c=1; c<=$numFolds; c++ ))
do
	for (( s=1; s<=$numStages; s++ ))
	do
		echo "================Fold :: $c Stage :: $s===================="
		iou_imgList="${tmpPath}fold${c}test${numFolds}.txt"
		${darwin}/scorePixelLabels -confusion -config ${tmpPath}config_fold${c}_stage${s}.xml -inLabels .fold${c}stage${s}.unary.txt ${iou_imgList}
		${darwin}/scorePixelLabels -confusion -config ${tmpPath}config_fold${c}_stage${s}.xml -inLabels .fold${c}stage${s}.iouunary.txt ${iou_imgList}
	done
done
rm -rf $tmpPath temp.sh allImages.txt
