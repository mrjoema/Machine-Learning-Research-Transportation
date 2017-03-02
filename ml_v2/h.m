[trainingData, trainingLabel, testingData, testingLabel] = LoadData();
 
% Show the original data
figure(1);
plot3(trainingData(:,1),trainingData(:,2),trainingData(:,3),'.');
hold off
xlabel('X');
ylabel('Y');
zlabel('Z');
view(-137,10);

% Hierarchical clustering
Z =linkage(trainingData,'single','euclidean','savememory','off');
c = cluster(Z,'maxclust',153);

% show the dendrogram
dendrogram(Z);

%# show points and clusters (color-coded)
figure(3), hold on
scatter3(trainingData(:,1),trainingData(:,2),trainingData(:,3),36,c)
view(3), axis vis3d, box on, rotate3d on
hold off

