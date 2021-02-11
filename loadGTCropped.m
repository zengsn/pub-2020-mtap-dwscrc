%% loadGTCropped.m
% GT face dataset

dbName = 'GTCropped';
load './GTCropped_32x32';
%inputData = double(inputData);
row=32;
col=32;

numOfClasses=50; % total classes
minSamples=15;  % the number of samples per class
mFirstSamples=4;  % The first m images of each class

minTrain=11;
maxTrain=11;
trainStep=1;

bestFactors = [3];
%bestFactors = [0.1];
disp('Data is ready!');