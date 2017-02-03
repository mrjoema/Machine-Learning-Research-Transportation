import sqlite3
import datetime

conn = sqlite3.connect('traffic.db')

cursor = conn.execute("SELECT * FROM TRAFFIC_TEST_RECORD")

#fo = open("raw-traffic-svm", "wb")

for row in cursor:
   id = row[0]
   speed =  row[1]
   date = row[2]
   linkid = row[3]
   speeding = row[4]

   d = datetime.datetime.strptime(date, "%m/%d/%Y %H:%M:%S")
   month = d.month

   day = d.day
   hour = d.hour
   min = d.minute
   sec = d.second
   arg = speeding, ' 1:', id, ' 2:', speed, ' 3:', linkid, ' 4:', month, ' 5:', day, ' 6:', hour, ' 7:', min, ' 8:', sec
   print(speeding, '1:',id, '2:',speed, '3:',linkid, '4:',month, '5:',day, '6:',hour, '7:',min, '8:',sec)
   #fo.write(line + '\n')

#fo.close()