[trainingData, trainingLabel, testingData, testingLabel] = LoadData();

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

