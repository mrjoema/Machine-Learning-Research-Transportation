[trainingData, trainingLabel, testingData, testingLabel] = LoadData();

% Show the original data
figure(1);
plot3(trainingData(:,1),trainingData(:,2),trainingData(:,3),'.');
hold off
xlabel('X');
ylabel('Y');
zlabel('Z');
view(-137,10);
 
%# K-means clustering
%# (K: number of clusters, G: assigned groups, C: cluster centers)
K = 153;
[G,C] = kmeans(trainingData, K);

%# show points and clusters (color-coded)
clr = lines(K);
figure(2), hold on
scatter3(trainingData(:,1), trainingData(:,2), trainingData(:,3), 36, clr(G,:), 'Marker','.')
scatter3(C(:,1), C(:,2), C(:,3), 100, clr, 'Marker','o', 'LineWidth',3)
hold off
view(3), axis vis3d, box on, rotate3d on


