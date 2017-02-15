% The scratch knn algorithm for bonus points

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

%# compute pairwise distances between each test instance vs. all training data
D = pdist2(testingData, trainingData, 'euclidean');
[D,idx] = sort(D, 2, 'ascend');

%# K nearest neighbors
K = 200;
D = D(:,1:K);
idx = idx(:,1:K);

% get the time difference after the model was trained
e = cputime-t;

%# majority vote
prediction = mode(trainingLabel(idx),2);

% Get the accuracy info
CP = classperf(testingLabel, prediction);

%# performance (confusion matrix and classification error)
C = confusionmat(testingLabel, prediction);
err = sum(C(:)) - sum(diag(C));