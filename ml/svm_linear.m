% load the dataset
S = load('USPS_all.mat', 'fea', 'gnd');
A = [S.fea];
B = [S.gnd];

% select first 7291 data as a training data
trainingData = A(1:7291,:);
% select first 7291 data as a training label
trainingLabel = B(1:7291,:);
% select first 7291 data as a testing data
testingData = A(7292:end,:);
% select first 7291 data as a testing label
testingLabel = B(7292:end,:);

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