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
 
% set start time
start = cputime;
% Generate weights
Wgts = rand(1,256); 

weuc = @(XI,XJ,W)(sqrt(bsxfun(@minus,XI,XJ).^2 * W')); 

% Find distance between all features
dList = pdist2(testingData, trainingData, @(Xi,Xj) weuc(Xi,Xj,Wgts)); 

% Sort distances from smallest
[dList,newDList] = sort(dList, 2, 'ascend'); 

%Specify k number of neighbors
k = 150; 

%Use only K nearest
newDList = newDList(:,1:k); 

% get runtime
runtime = cputime-start;

% test the model
prediction = mode(trainingLabel(newDList),2);

% Get the accuracy info
CP = classperf(testingLabel, prediction);

% Get the confusion matrix
C = confusionmat(testingLabel, prediction);

