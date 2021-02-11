%% classifyBySCRC.m
% See Zeng et al., 2017, Multi-media Tools and Applications, 
% Multiplication fusion of sparse and collaborative representation for robust face recognition
function [deviations,accuracy] = classifyBySCRC(trainData,numOfTrain,testData,testLabel)
tic
fprintf('SCRC: 1,');
numOfAllTest = size(testData,1);
errorsSRC=zeros(numOfAllTest,1);
dimOfData = size(trainData,2);
numOfClasses = max(testLabel);
preserved=inv(trainData*trainData'+0.01*eye(size(trainData,1)))*trainData;
deviations=zeros(numOfAllTest,numOfClasses);
parfor kk=1:numOfAllTest
    if mod(kk,floor(numOfAllTest/10))==0
        fprintf('%d,',kk);
    end
    testSample=testData(kk,:);
    % SRC
    [solutionSRC, ~] = SolveFISTA(trainData',testSample');
    %[solutionSRC, ~] = SolveOMP(trainData',testSample','isnonnegative',1);
    % CRC 
    solutionCRC = preserved*testSample';
    % coefficients
    contributionSCRC = zeros(dimOfData,numOfClasses);
    for cc=1:numOfClasses % Multiplication fusion
        for tt=1:numOfTrain % C(i) = sum(S(i)*T)
            contributionSCRC(:,cc)  = contributionSCRC(:,cc)+solutionSRC((cc-1)*numOfTrain+tt)*solutionCRC((cc-1)*numOfTrain+tt)*trainData((cc-1)*numOfTrain+tt,:)';
        end
    end
    %contributions(kk,:,:) = contributionSCRC;
    % 计算距离|残差|余量
    deviationSCRC = zeros(1,numOfClasses);
    for cc=1:numOfClasses % r(i) = |D(i)-C(i)|
        deviationSCRC(cc)=norm(testSample'-contributionSCRC(:,cc));
    end
    deviations(kk,:)=deviationSCRC;
    % 保存识别结果
    [~,labelSRC]=min(deviationSCRC);
    if labelSRC~=testLabel(kk)
        errorsSRC(kk)=1;
    end  
end
accuracy = 1-sum(errorsSRC)/numOfAllTest; % print
timeSRC = toc;
fprintf('done in %.1f(sec). \n',timeSRC);
end