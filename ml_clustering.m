dbfile = fullfile('traffic.db');

conn = sqlite(dbfile);
curs = fetch(conn,'select id, speed, linkid from TRAFFIC_RECORD');
label = fetch(conn,'select speeding from TRAFFIC_RECORD');
%X = curs(: , 3);
%formatIn = 'mm/dd/yyyy HH:MM:SS';
%DateVec = datevec(X,formatIn);

%month = DateVec(:, 2);
%id = curs(:,2);
%id = str2double(id);

%NewData = horzcat(month, id);



%curs = fetch(conn,'select * from TRAFFIC_RECORD')
labelDouble= cell2mat(label);
labelDouble = double(labelDouble);
%cursDouble = cell2mat(curs);
id = curs(: , 1);
id= cell2mat(id);
id = double(id);
speed = curs(:,2);
speed= cell2mat(speed);
speed = double(speed);
linkid = curs(:,3);
linkid= cell2mat(linkid);
linkid = double(linkid);
A = horzcat(id, speed, linkid);
model = svmtrain(labelDouble, A ,'libsvm_options');

curs = fetch(conn,'select id, speed, linkid from TRAFFIC_TEST_RECORD');
label = fetch(conn,'select speeding from TRAFFIC_TEST_RECORD');
labelDouble= cell2mat(label);
TESTlabelDouble = double(labelDouble);
id = curs(: , 1);
id= cell2mat(id);
id = double(id);
speed = curs(:,2);
speed= cell2mat(speed);
speed = double(speed);
linkid = curs(:,3);
linkid= cell2mat(linkid);
linkid = double(linkid);
TEST = horzcat(id, speed, linkid);

[predicted_label, accuracy, decision_values, prob_estimates] = svmpredict(TESTlabelDouble, TEST, model , 'libsvm_options');