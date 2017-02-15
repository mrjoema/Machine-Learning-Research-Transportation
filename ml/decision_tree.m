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

% get the current cputime
t = cputime;

% create classification tree using the default settings
ctree = fitctree(trainingData,trainingLabel); 

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
