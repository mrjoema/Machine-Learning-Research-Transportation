clear
close all
clc
 
% load and show the original data
conn = sqlite('traffic.db');
sqlquery = 'select * from traffic_record';
results = fetch(conn,sqlquery);
formatIn = 'mm/dd/yyyy HH:MM:SS';
time = datevec(results(:,3),formatIn);

carID = results(:,1);
carID = double(cell2mat(carID));
carSpeed = results(:,2);
carSpeed = double(cell2mat(carSpeed));
camID = results(:,4);
camID = double(cell2mat(camID));
isSpeeding = results(:,5);
isSpeeding = double(cell2mat(isSpeeding));
C = horzcat(carID,carSpeed,time,camID,isSpeeding);
 
% testing data
sqlquery = 'select * from traffic_test_record';
results = fetch(conn,sqlquery);
formatIn = 'mm/dd/yyyy HH:MM:SS';
time = datevec(results(:,3),formatIn);

carID = results(:,1);
carID = double(cell2mat(carID));
carSpeed = results(:,2);
carSpeed = double(cell2mat(carSpeed));
camID = results(:,4);
camID = double(cell2mat(camID));
isSpeeding = results(:,5);
isSpeeding = double(cell2mat(isSpeeding));
TestC = horzcat(carID,carSpeed,time,camID,isSpeeding);

close(conn)

% select first 7291 data as a training data
trainingData = C(:,1:9);
% select first 7291 data as a training label
trainingLabel = C(:,end);
% select first 7291 data as a testing data
testingData = TestC(:,1:9);
% select first 7291 data as a testing label
testingLabel = TestC(:,end);

% setup the svm template
t = templateSVM('Standardize',1,'KernelFunction','polynomial','PolynomialOrder',2);

% get the current CPU time
t1 = cputime;

% Fit multiclass models for support vector machines or other classifiers
% Train the svm model using polynomial kernel function
Mdl = fitcecoc(trainingData,trainingLabel,'Learners',t,'FitPosterior',0,'Verbose',0);

% get the time difference after the model was trained
e = cputime - t1;

% Test the svm model
[label,score] = predict(Mdl,testingData);

% Get the accuracy rate
CP = classperf(testingLabel, label);
% Get the confusion matrix
C = confusionmat(testingLabel,label);