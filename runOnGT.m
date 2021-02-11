% runOnGT.m

clear all;
addpath(genpath('./FISTA'));
addpath(genpath('./OMP'));

%% Load data
loadGTCropped;

%% Train with different number of training samples
for numOfTrain=minTrain:trainStep:maxTrain
    % Prepare the training data
    prepareTrainData;
    
    % SCRC on the original samples
    [deviationsOrig,accuracyOrig] = classifyBySCRC(trainData_0,numOfTrain,testData,testLabel);
    
    % SCRC on the virtual samples
    [deviationsVirt,accuracyVirt] = classifyBySCRC(trainData,numOfTrain*2,testData,testLabel);
    
    % Fusion using the set factor
    factor=bestFactors(1);
    errorsFusion=0;
    for kk=1:numOfAllTest
        deviationOrig=deviationsOrig(kk,:);
        deviationVirt=deviationsVirt(kk,:);
        % one can try a more sophisticated fusion here. 
        deviationFusion=deviationOrig+factor*deviationVirt;
        [min_value labelFusion]=min(deviationFusion);
        if labelFusion~=testLabel(kk)
            errorsFusion=errorsFusion+1;
        end
    end
    accuracyFusion = 1-errorsFusion/numOfAllTest; % print
    fprintf('Fusion accuracyFusion=%.4f with factor=%.1f. \n\n',accuracyFusion,factor);
end
