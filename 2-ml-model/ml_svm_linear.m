[trainingData, trainingLabel, testingData, testingLabel] = LoadData();

% setup the model
t = templateSVM('Standardize',1,'KernelFunction','linear');

% get the current cputime
t1 = cputime;

% Fit multiclass models for support vector machines or other classifiers
% Train the svm model using linear kernel function
Mdl = fitcecoc(trainingData,trainingLabel,'Learners',t,'FitPosterior',1,'Verbose',0);

% get the time difference after the model was trained
e = cputime-t1;

% Test the svm model
[label,score] = predict(Mdl,testingData);

% Get the accuracy rate
CP = classperf(testingLabel, label);

% Get the confusion matrix
C = confusionmat(testingLabel,label);

fprintf('SVM Linear Accuracy: %f\n',CP.CorrectRate);
fprintf('SVM Linear F1-Score (Mean): %f\n',meanF1);
fprintf('SVM Linear Precision (Mean): %f\n',mean(precision));
fprintf('SVM Linear Recall (Mean): %f\n',mean(recall));