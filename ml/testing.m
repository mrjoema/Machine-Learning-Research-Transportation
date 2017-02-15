clear all; 
load heart; 
format compact; 
% NOTE: no semicolons at the end of the next two lines 
[ trainScoreMean, testScoreMean ] = featureSubsetScore( dat( :, [ 1 : 13 ] ), label );

disp('[ trainScoreMean, testScoreMean ] = featureSubsetScore( dat( :, [ 1 : 13 ] ), label ):');
fprintf(1, 'trainScoreMean: %5.4f%', trainScoreMean);
fprintf(1, '    testScoreMean: %5.4f% \n', testScoreMean);

disp(' ');

[ trainScoreMean, testScoreMean ] = featureSubsetScore( dat( :, [ 1, 3, 5 ] ), label ); 
disp('[ trainScoreMean, testScoreMean ] = featureSubsetScore( dat( :, [ 1, 3, 5 ] ), label ):');
fprintf(1, 'trainScoreMean: %5.4f%', trainScoreMean);
fprintf(1, '    testScoreMean: %5.4f% \n', testScoreMean);

disp(' ');
%scoreBest = 0;

