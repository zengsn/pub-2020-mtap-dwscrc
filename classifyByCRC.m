%% classifyByCRC.m
function [contributions,accuracy] = classifyByCRC(trainData,numOfTrain,testData,testLabel)
tic
fprintf('CRC: 1,');
preserved=inv(trainData*trainData'+0.01*eye(size(trainData,1)))*trainData;
numOfAllTest = size(testData,1);
errorsCRC=zeros(numOfAllTest,1);
dimOfData = size(trainData,2);
numOfClasses = max(testLabel);
contributions = zeros(numOfAllTest,dimOfData,numOfClasses);
parfor kk=1:numOfAllTest
    if mod(kk,floor(numOfAllTest/10))==0
        fprintf('%d,',kk);
    end
    testSample=testData(kk,:);
    % CRC
    solutionCRC = preserved*testSample';
    contributionCRC = zeros(dimOfData,numOfClasses);
    for cc=1:numOfClasses
        for tt=1:numOfTrain % C(i) = sum(S(i)*T)
            contributionCRC(:,cc)  = contributionCRC(:,cc)+solutionCRC((cc-1)*numOfTrain+tt)*trainData((cc-1)*numOfTrain+tt,:)';
        end
    end
    contributions(kk,:,:) = contributionCRC;
    % 计算距离|残差|余量
    deviationCRC = zeros(1,numOfClasses);
    for cc=1:numOfClasses % r(i) = |D(i)-C(i)|
        deviationCRC(cc)=norm(testSample'-contributionCRC(:,cc));
    end
    
    % 保存识别结果
    [~,labelCRC]=min(deviationCRC);
    if labelCRC~=testLabel(kk)
        errorsCRC(kk)=1;
    end  
end
accuracy = 1-sum(errorsCRC)/numOfAllTest; % print
timeCRC = toc;
fprintf('done in %.1f(sec). \n',timeCRC);
end