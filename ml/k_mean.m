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

% load and show the original data
threshold = 0.45;  % try 0.43, 0.46, 0.49, 0.51, etc. for pre-preocessing
[map,s] = ReadMRC('1oaiA00.mrc');
densityIndx = find(map>threshold);
size = size(map);
[x,y,z] = ind2sub(size,densityIndx); 
xyzPoints = horzcat(x,y,z);
 
figure(1);
plot3(C(:,1),C(:,2),C(:,3),'.');
hold off
xlabel('X');
ylabel('Y');
zlabel('Z');
view(-137,10);
 
%# K-means clustering
%# (K: number of clusters, G: assigned groups, C: cluster centers)
K = 12;
[G,D] = kmeans(C, K);

%# show points and clusters (color-coded)
clr = lines(K);
figure(2), hold on
scatter3(C(:,1), C(:,2), C(:,3), 36, clr(G,:), 'Marker','.')
scatter3(D(:,1), D(:,2), D(:,3), 100, clr, 'Marker','o', 'LineWidth',3)
hold off
view(3), axis vis3d, box on, rotate3d on


%figure(1);
%plot3(xyzPoints(:,1), xyzPoints(:,2), xyzPoints(:,3), 36, clr(G,:), 'Marker','.');
%scatter3(C(:,1), C(:,2), C(:,3), 100, clr, 'Marker','o', 'LineWidth',3)
%hold off
%xlabel('X');
%ylabel('Y');
%zlabel('Z');
%view(-137,10);