[trainingData, trainingLabel, testingData, testingLabel] = LoadData();

nTrain = length( trainingLabel );
nTest = length( testingLabel );

k = 5;
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