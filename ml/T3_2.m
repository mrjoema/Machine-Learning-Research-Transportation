clear all; 
load heart; 
format compact; 

scoreBest = 0;
for m = 1 : 1000
     rng(m);
     FTrial = datasample(dat,270,'Replace',false);
     % modify it by hand
     k = 2;
     FTrial = FTrial(:,1:k);
     [trainScoreMean, testScoreMean] = featureSubsetScore(FTrial, label); 
     if testScoreMean > scoreBest
         scoreBest = testScoreMean;
         FSet = FTrial;
     end
end
 
% disp(scoreBest);
% disp(FSet);
 