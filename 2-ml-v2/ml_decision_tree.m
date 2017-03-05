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

precision = diag(C)./sum(C,2);
recall = diag(C)./sum(C,1)';

precision(isnan(precision)) = 0;
recall(isnan(recall))=0;

f1Scores = 2*(precision.*recall)./(precision + recall);

f1Scores(isnan(f1Scores)) = 0;

meanF1 = mean(f1Scores);


% stats.accuracy = (TP + TN)/(TP + FP + FN + TN) ; the average accuracy is returned
% stats.precision = TP / (TP + FP)                  % for each class label
% stats.sensitivity = TP / (TP + FN)                % for each class label
% stats.specificity = TN / (FP + TN)                % for each class label
% stats.recall = sensitivity                        % for each class label
% stats.Fscore = 2*TP /(2*TP + FP + FN)            % for each class label
