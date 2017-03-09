[trainingData, trainingLabel, testingData, testingLabel] = LoadData();

% get the current cputime
t = cputime;

% create classification tree using the default settings
ctree = fitctree(trainingData,trainingLabel,'MinLeafSize',3); 

% get the time difference after the model was trained
e = cputime-t;

% graphic description
view(ctree,'mode','graph') 

% Test the tree model
label = predict(ctree,testingData);

% show the accuracy info
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

fprintf('Decision Tree Accuracy: %f\n',CP.CorrectRate);
fprintf('Decision Tree F1-Score (Mean): %f\n',meanF1);
fprintf('Decision Tree Precision (Mean): %f\n',mean(precision));
fprintf('Decision Tree Recall (Mean): %f\n',mean(recall));
