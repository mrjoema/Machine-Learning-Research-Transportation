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

% api doc: https://www.mathworks.com/help/stats/fitcecoc.html

% get the current cpu time
t = cputime;

% create classification tree with customization of the branch
ctree = fitctree(trainingData,trainingLabel,'MaxNumSplits',2,'CrossVal','on');


% create classification tree with the customization of leafs
%ctree = fitctree(trainingData,trainingLabel,'MinLeafSize',800,'CrossVal','on');

% compute the time difference after the model was trained
e = cputime-t;

% graphic description
view(ctree.Trained{1},'Mode','graph');

% Test the decision tree model
label = predict(ctree.Trained{1},testingData);

% Get the accuracy rate
CP = classperf(testingLabel, label);
% Get the confusion matrix
C = confusionmat(testingLabel,label);
