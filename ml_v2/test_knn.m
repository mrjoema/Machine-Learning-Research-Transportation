[trainingData, trainingLabel, testingData, testingLabel] = LoadData();

mdl = fitcknn(trainingData,trainingLabel,'NumNeighbors',4);

% Test the tree model
label = predict(mdl,testingData);

% show the accuracy info
CP = classperf(testingLabel, label);

% Get the confusion matrix
C = confusionmat(testingLabel,label);