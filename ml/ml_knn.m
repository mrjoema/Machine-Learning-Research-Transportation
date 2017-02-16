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


nTrain = length( trainingLabel );
nTest = length( testingLabel );

k = 1;
%%&& knnsearch() doesn't exist in R2009a!!
testPredIdx = knnsearch( trainingData, testingData, 'K', k );  
% get labels of all k-nearest neighbors for each test sample
testPredAll = trainingLabel( testPredIdx );    
testPred = zeros( nTest, 1 );
for te = 1 : nTest
    % get label(s) which occurs most often among neighbors
    [ modeLabel, modeCount, allMode ] = mode( testPredAll( te, : ) );
    % if there is a tie for most frequent label, pick one at random
    allMode = allMode{ 1 };
    nMode = length( allMode );
    if ( nMode > 1 )
        RandStream.setDefaultStream( RandStream( 'mt19937ar', 'Seed', te ) );
        rp = randperm( nMode );
        modeLabel = allMode( rp( 1 ) );
    end
    testPred( te ) = modeLabel;    
end

nTestCorrect = sum( testingLabel == testPred );
fprintf( 1, 'correct predictions on test set     :   %d / %d,  %5.2f%%\n', ...
    nTestCorrect, nTest, 100 * nTestCorrect / nTest );
[ mat, order ] = confusionmat( testingLabel, testPred );
disp( ' ' );
disp( order' );
disp( mat );
