[trainingData, trainingLabel, testingData, testingLabel] = LoadData();

% get the current CPU time
t1 = cputime;

% knn algorithm
Mdl = fitcknn(trainingData,trainingLabel,'NumNeighbors',127,'NSMethod','exhaustive','Distance', 'jaccard');

% get the time difference after the model was trained
e = cputime - t1;

% Test the svm model
[label,score] = predict(Mdl,testingData);

% Get the accuracy rate
CP = classperf(testingLabel, label);
% Get the confusion matrix
C = confusionmat(testingLabel,label);