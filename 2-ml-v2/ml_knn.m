[trainingData, trainingLabel, testingData, testingLabel] = LoadData();

% get the current CPU time
t1 = cputime;

% knn algorithm
Mdl = fitcknn(trainingData,trainingLabel,'NumNeighbors',127,'NSMethod','exhaustive','Distance', 'jaccard');

% get the time difference after the model was trained
e = cputime - t1;

% Test the knn model
[label,score] = predict(Mdl,testingData);

% Get the accuracy rate
CP = classperf(testingLabel, label);
% Get the confusion matrix
C = confusionmat(testingLabel,label);

precision = diag(C)./sum(C,2);
recall = diag(C)./sum(C,1)';

precision(isnan(precision)) = 0;
recall(isnan(recall))=0;
f1Scores = 2*(precision.*recall)./(precision + recall);
f1Scores(isnan(f1Scores)) = 0;
meanF1 = mean(f1Scores);

fprintf('KNN Accuracy: %f\n',CP.CorrectRate);
fprintf('KNN Accuracy F1-Score (Mean): %f\n',meanF1);
fprintf('KNN Precision (Mean): %f\n',mean(precision));
fprintf('KNN Recall (Mean): %f\n',mean(recall));
fprintf('Time: %f\n',e);
