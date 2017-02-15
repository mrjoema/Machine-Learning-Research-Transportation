function [trainScoreMean, testScoreMean] = featureSubsetScore(dat, label) 
    trainScoreMean = 0;
    testScoreMean = 0;
    for m = 1:10
        rng( m );
        nInst = size( dat, 1 );
        rp = randperm( nInst );
        nTrain = 200;
        nTest = nInst - nTrain;

        trainDat = dat( rp( 1 : nTrain ), : );
        trainLabel = label( rp( 1 : nTrain ) );
        testDat = dat( rp( nTrain + 1 : end ), : );
        testLabel = label( rp( nTrain + 1 : end ) );

        B = mnrfit( trainDat, trainLabel );

        % output from mnrval has two columns of probabilities, one for each class
        pred = mnrval( B, trainDat );

        % convert probabilities in column 2 into class labels (1 and 2) by comparing to threshold
        threshold = 0.5;
        trainPred = ( pred( :, 2 ) > threshold ) + 1;   % have to add 1 to get class labels 1 and 2

        pred = mnrval( B, testDat );
        testPred = ( pred( :, 2 ) > threshold ) + 1;

        nTrainCorrect = sum( trainLabel == trainPred );
        nTestCorrect = sum( testLabel == testPred );

        trainScore = nTrainCorrect / nTrain; 
        testScore = nTestCorrect / nTest; 

        trainScoreMean = trainScoreMean + trainScore;
        testScoreMean = testScoreMean + testScore;

    end
    
        trainScoreMean = trainScoreMean / 10;
        testScoreMean = testScoreMean / 10;
    

end 
