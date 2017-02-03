[train_label, train_inst] = libsvmread(fullfile('raw-traffic-svm'));
[N D] = size(heart_scale_inst);

% Determine the train and test index
trainIndex = zeros(N,1); trainIndex(1:N) = 1;
trainData = train_inst(trainIndex==1,:);
trainLabel = train_label(trainIndex==1,:);

[test_label, test_inst] = libsvmread(fullfile('raw-test-traffic-svm'));
[N D] = size(test_inst);

testIndex = zeros(N,1); testIndex(1:N) = 1;
testData = test_inst(testIndex==1,:);
testLabel = test_label(testIndex==1,:);

% Train the SVM
model = svmtrain(trainLabel, trainData);
% Use the SVM model to classify the data
[predict_label, accuracy, prob_values] = svmpredict(testLabel, testData, model); % run the SVM model on the test data