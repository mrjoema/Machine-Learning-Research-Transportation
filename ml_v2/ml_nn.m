
[trainFea, trainLabel, testFea, testLabel] = LoadData();

%Transpose before training
x = trainFea(:, :)';
%t = full(ind2vec(trainLabel(:, :)'));
t = trainLabel(:,:)';

layer = randperm(5);
%Generate random hidden layer and neurons
setup = randperm(200,5); 

%Set net train Parameters
net = patternnet(setup);
net.trainFcn = 'trainscg';
net.trainParam.lr = 0.4783510;
net.trainParam.epochs = 470;
net.trainParam.max_fail = 10;
view(net)
[net,tr] = train(net,x,t);



nntraintool

plotperform(tr)


testX = testFea(:,:)';
testT =testLabel(:, :)';
testY = net(testX);
testIndices = vec2ind(testY);


plotconfusion(testT,testY)


[c,cm] = confusion(testT,testY);

fprintf('Percentage Correct Classification   : %f%%\n', 100*(1-c));
fprintf('Percentage Incorrect Classification : %f%%\n', 100*c);

plotroc(testT,testY)


