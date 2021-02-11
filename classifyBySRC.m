%% classifyBySRC.m
function [contributions,accuracy] = classifyBySRC(trainData,numOfTrain,testData,testLabel)
tic
fprintf('SRC: 1,');
numOfAllTest = size(testData,1);
errorsSRC=zeros(numOfAllTest,1);
dimOfData = size(trainData,2);
numOfClasses = max(testLabel);
contributions = zeros(numOfAllTest,dimOfData,numOfClasses);
parfor kk=1:numOfAllTest
    if mod(kk,floor(numOfAllTest/10))==0
        fprintf('%d,',kk);
    end
    testSample=testData(kk,:);
    % SRC
    %[solutionSRC, total_iter] = SolveFISTA(trainData',testSample');
    [solutionSRC, ~] = SolveOMP(trainData',testSample','isnonnegative',1);
    contributionSRC = zeros(dimOfData,numOfClasses);
    for cc=1:numOfClasses
        for tt=1:numOfTrain % C(i) = sum(S(i)*T)
            contributionSRC(:,cc)  = contributionSRC(:,cc)+solutionSRC((cc-1)*numOfTrain+tt)*trainData((cc-1)*numOfTrain+tt,:)';
        end
    end
    contributions(kk,:,:) = contributionSRC;
    % 计算距离|残差|余量
    deviationSRC = zeros(1,numOfClasses);
    for cc=1:numOfClasses % r(i) = |D(i)-C(i)|
        deviationSRC(cc)=norm(testSample'-contributionSRC(:,cc));
    end
    
    % 保存识别结果
    [~,labelSRC]=min(deviationSRC);
    if labelSRC~=testLabel(kk)
        errorsSRC(kk)=1;
    end  
end
accuracy = 1-sum(errorsSRC)/numOfAllTest; % print
timeSRC = toc;
fprintf('done in %.1f(sec). \n',timeSRC);
end