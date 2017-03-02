[trainingData, trainingLabel, testingData, testingLabel] = LoadData();


count=0;

% init the parameters
bestK = 0;
bestDSMethod = 'euclidean';
bAcc = 0;

while 1
    % Set the training function (Parameter)

    rng('shuffle');
    
    meanAcc = 0;

    a = 1;
    b = 300;
    k = int8((b-a).*rand(1,1) + a);
    
    s = {'cityblock', 'chebychev', 'correlation', 'cosine', 'euclidean', 'hamming', 'jaccard', 'mahalanobis', 'minkowski','seuclidean', 'spearman'};
    DSMethod = s(randi(11,1,1));
    
    %Split into 10 parts for kfold.  9 Training 1 testing
    indices = crossvalind('Kfold',trainingLabel,10);
    for i = 1:10 %
        % break the datasets into smaller subsets
        testIdx = (indices == i);                %# get indices of test instances
        trainIdx = ~testIdx;                     %# get indices training instances

        % NN train    
        trainFea = trainingData(trainIdx,:); % set the training data using 9 parts
        trainLabel = trainingLabel(trainIdx,:); % set the training labels using 9 parts
        testFea = trainingData(testIdx,:); % set the testing data using 1 parts
        testLabel = trainingLabel(testIdx,:); % set the training labels using 1 parts
        
        % knn algorithm
        Mdl = fitcknn(trainFea,trainLabel,'NumNeighbors',k,...
                    'NSMethod','exhaustive','Distance',DSMethod{1},...
                    'Standardize',1);
        
        % Test the svm model
        [label,score] = predict(Mdl,testFea);
        
        % Get the accuracy rate
        CP = classperf(testLabel, label);
   
        correct = CP.CorrectRate;

        correctPerc = 100*correct;

        meanAcc = meanAcc + correctPerc;

    end
    
    % get the mean after running 10 times
    meanAcc = meanAcc / 10;

    if(meanAcc >= bAcc)
        bestK = k;
        bestDSMethod = DSMethod{1};
        bAcc = meanAcc;
    end
    
    
    count = count + 1;
    
    % print output
    fprintf('Best Accuracy: %f\n',bAcc);
    fprintf('Best K: %i\n',bestK);
    fprintf('Best DS method: %s\n',bestDSMethod);
    fprintf('Counter: %i\n',count);
    disp('=================================');

end