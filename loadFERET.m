%% loadFERET.m
% FERET face dataset

dbName = 'FERET';

load './FERET_32x32_d';
%inputData = double(inputData);
row=32;
col=32;

numOfClasses=200; % total classes
minSamples=7;  % the number of samples per class
mFirstSamples=4;  % The first m images of each class

minTrain=5;
maxTrain=5;
trainStep=1;

%bestFactors=[2.0];
%bestFactors=[0.1];
bestFactors=[3.0];