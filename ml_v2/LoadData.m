function [trainingData, trainingLabel, testingData, testingLabel] = LoadData() 
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
    %isSpeeding = results(:,5);
    %isSpeeding = double(cell2mat(isSpeeding));
    C = horzcat(carID,carSpeed,time,camID);

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
    %isSpeeding = results(:,5);
    %isSpeeding = double(cell2mat(isSpeeding));
    TestC = horzcat(carID,carSpeed,time,camID);

    close(conn)

    % select first 7291 data as a training data
    trainingData = C(:,1:8);
    % select first 7291 data as a training label
    trainingLabel = C(:,end);
    % select first 7291 data as a testing data
    testingData = TestC(:,1:8);
    % select first 7291 data as a testing label
    testingLabel = TestC(:,end);

end 